library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_module is
    port (  
        clk: in std_logic;
        buttons: in std_logic_vector(2 downto 0);
        switches: in std_logic_vector(13 downto 0);
        red: out std_logic_vector(3 downto 0);
        green: out std_logic_vector(3 downto 0);
        blue: out std_logic_vector(3 downto 0);
        hsync: out std_logic;
        vsync: out std_logic
	 );
end;

architecture behavioral of vga_module is
    component debouncer is
        generic(
            period: integer;
            width: integer
        );
        port(
            clk:in std_logic;
            input:in std_logic;
            output:out std_logic
        );
    end component;
    
    component sync_signal_generator is
        port(
            clk: in std_logic;
            reset: in std_logic;
            pixel_clk: in std_logic;
            blank: out std_logic;
            hor_sync: out std_logic;
            ver_sync: out std_logic;
            scan_x: out std_logic_vector(9 downto 0);
            scan_y: out std_logic_vector(8 downto 0)
        );
    end component;

    component clock_divider is
        port(
            clk: in std_logic;
            reset: in std_logic;
            twentyfive_MHz: out std_logic;
            kHz: out std_logic;
            hHz: out std_logic;
            dHz: out std_logic
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
    
    signal reset: std_logic;
    signal d_switches: std_logic_vector(14 downto 0);
    signal d_buttons: std_logic_vector(2 downto 0);
    signal inc_size, dec_size: std_logic;
    signal mode: std_logic_vector(1 downto 0);
    signal color: std_logic_vector(11 downto 0);
    signal pixel_clk, kHz, hHz, dHz: std_logic;
    signal blank: std_logic;
    signal scan_x: std_logic_vector(9 downto 0);
    signal scan_y: std_logic_vector(8 downto 0);
    signal next_red, next_green, next_blue: std_logic_vector(3 downto 0);
    signal stripe_red, stripe_green, stripe_blue: std_logic_vector(3 downto 0);
    signal box_size_enable, letter_size_enable: std_logic;
    signal box_size, size: std_logic_vector(8 downto 0);
    signal letter_size: std_logic_vector(4 downto 0);
    signal colored: std_logic;
    signal not_blank: std_logic;
begin
    reset <= d_buttons(0);
    inc_size <= d_buttons(1); 
    dec_size <= d_buttons(2);
    mode <= d_switches(1 downto 0);
    color <= d_switches(13 downto 2);
    
    box_size_enable <= hHz when (mode = "00") else '0';
    letter_size_enable <= dHz when (mode = "01") else '0';
    size <= ("0000" & letter_size) when (mode(0) = '1') else box_size;
    not_blank <= blank;    
    
    debounce_switches: for i in 0 to 14 generate
        debounce_i: debouncer
            generic map(
                period => 1000000,
                width => 20
            )
            port map(
                clk => clk,
                input => switches(i),
                output => d_switches(i)
            );        
    end generate;

    debounce_buttons: for i in 0 to 2 generate
        debounce_i: debouncer
            generic map(
                period => 1000000,
                width => 20
            )
            port map(
                clk => clk,
                input => buttons(i),
                output => d_buttons(i)
            );
    end generate;

    vga_sync: sync_signal_generator
        port map(
            clk => clk,
            reset => reset,
            pixel_clk => pixel_clk,
            blank => blank,
            hor_sync => hsync,
            ver_sync => vsync,
            scan_x => scan_x,
            scan_y => scan_y
        );

    divider: clock_divider
        port map(
            clk => clk,
            reset => reset,
            twentyfive_MHz => pixel_clk,
            kHz => kHz,
            hHz => hHz,
            dHz => dHz
        );
    
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
            up => inc_size,
            down => dec_size,
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
            up => inc_size,
            down => dec_size,
            value => letter_size
        );
    
    process(mode(1), stripe_red, stripe_green, stripe_blue, color, colored) begin
        if (mode(1) = '1') then
            next_red <= stripe_red;
            next_green <= stripe_green;
            next_blue <= stripe_blue;
        else
            if (colored = '1') then
                next_red <= color(11 downto 8);
                next_green <= color(7 downto 4);
                next_blue <= color(3 downto 0);
            else
                next_red <= "1111";
                next_green <= "1111";
                next_blue <= "1111";
            end if;
        end if;
    end process;
    
    process(next_red, next_green, next_blue, blank) begin
        if (blank = '0') then
            red <= next_red;
            green <= next_green;
            blue <= next_blue;
        else
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        end if;
    end process;
end;
