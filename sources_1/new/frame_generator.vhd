library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity frame_generator is
    port(
        clk: in std_logic;
        reset: in std_logic;
        pixel_clk: in std_logic;
        kHz: in std_logic;
        hHz: in std_logic;
        dHz: in std_logic;
        scan_x: in std_logic_vector(9 downto 0);
        scan_y: in std_logic_vector(8 downto 0);
        blank: in std_logic;
        mode: in std_logic_vector(1 downto 0);
        size_inc: in std_logic;
        size_dec: in std_logic;
        color: in std_logic_vector(11 downto 0);
        red: out std_logic_vector(3 downto 0);
        green: out std_logic_vector(3 downto 0);
        blue: out std_logic_vector(3 downto 0)
    );
end;

architecture behavioural of frame_generator is
    component bouncing_box is
        port(
            clk: in std_logic;
            reset: in std_logic;
            kHz: in std_logic;
            scan_x: in std_logic_vector(9 downto 0);
            scan_y: in std_logic_vector(8 downto 0);
            mode: in std_logic;
            size: in std_logic_vector(8 downto 0);
            colored: out std_logic
        );
    end component;
    
    component vga_stripes_dff is
        port(
            clk: in std_logic;
            reset: in std_logic;
            pixel_clk: in std_logic;
            enable: in std_logic;
            mode: in std_logic;
            red: out std_logic_vector(3 downto 0);
            green: out std_logic_vector(3 downto 0);
            blue: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component up_down_counter is
        generic (
           width: integer
        );
        port (
            clk: in std_logic;
            reset: in std_logic;
            enable: in std_logic;
            up: in std_logic;
            down: in std_logic;
            value: out std_logic_vector(width - 1 downto 0)
        );
    end component;
    
    signal stripe_red, stripe_green, stripe_blue: std_logic_vector(3 downto 0);
    signal box_size_enable, letter_size_enable: std_logic;
    signal box_size, size: std_logic_vector(8 downto 0);
    signal letter_size: std_logic_vector(4 downto 0);
    signal colored: std_logic;
    signal not_blank: std_logic;
begin
    box_size_enable <= hHz when (mode = "00") else '0';
    letter_size_enable <= dHz when (mode = "01") else '0';
    size <= ("0000" & letter_size) when (mode(0) = '1') else box_size;
    not_blank <= blank;

    box: bouncing_box
        port map(
            clk => clk,
            reset => reset,
            kHz => kHz,
            scan_x => scan_x,
            scan_y => scan_y,
            mode => mode(0),
            size => size,
            colored => colored
        );
    
    stripes: vga_stripes_dff
        port map(
            clk => clk,
            reset => reset,
            pixel_clk => pixel_clk,
            enable => not_blank,
            mode => mode(0),
            red => stripe_red,
            green => stripe_green,
            blue => stripe_blue
        );
    
    box_size_counter: up_down_counter
        generic map(
            width => 9
        )
        port map(
            clk => clk,
            reset => reset,
            enable => box_size_enable,
            up => size_inc,
            down => size_dec,
            value => box_size
        );
        
    letter_size_counter: up_down_counter
        generic map(
            width => 5
        )
        port map(
            clk => clk,
            reset => reset,
            enable => letter_size_enable,
            up => size_inc,
            down => size_dec,
            value => letter_size
        );
    
    process(mode(1), stripe_red, stripe_green, stripe_blue, color, colored) begin
        if (mode(1) = '1') then
            red <= stripe_red;
            green <= stripe_green;
            blue <= stripe_blue;
        else
            if (colored = '1') then
                red <= color(11 downto 8);
                green <= color(7 downto 4);
                blue <= color(3 downto 0);
            else
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;
    end process;
end;