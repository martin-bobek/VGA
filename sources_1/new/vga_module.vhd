library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_module is
    port (  
        clk: in std_logic;
        buttons: in std_logic_vector(2 downto 0);
        switches: in std_logic_vector(14 downto 0);
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

-- ADDED
component clock_divider is
Port (  clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        enable: in STD_LOGIC;
        kHz: out STD_LOGIC;	  
        seconds_port: out STD_LOGIC_VECTOR(4-1 downto 0);     -- unused
        ten_seconds_port: out STD_LOGIC_VECTOR(3-1 downto 0); -- unused
        minutes_port: out STD_LOGIC_VECTOR(4-1 downto 0);     -- unused
        ten_minutes_port: out STD_LOGIC_VECTOR(3-1 downto 0); -- unused
        twentyfive_MHz: out STD_LOGIC;
        hHz: out STD_LOGIC;
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
 Port (  clk : in  STD_LOGIC;
         reset : in  STD_LOGIC;
         scan_line_x: in STD_LOGIC_VECTOR(10 downto 0);
         scan_line_y: in STD_LOGIC_VECTOR(10 downto 0);
         box_color: in STD_LOGIC_VECTOR(11 downto 0);
         box_width: in STD_LOGIC_VECTOR(8 downto 0);
         box_or_letter: in STD_LOGIC;
         kHz: in STD_LOGIC;
         red: out STD_LOGIC_VECTOR(3 downto 0);
         blue: out STD_LOGIC_VECTOR(3 downto 0);
         green: out std_logic_vector(3 downto 0)
      );
end component;
-- END ADDED

-- Signals:
signal reset: std_logic;
signal vga_select: std_logic;

signal disp_blue: std_logic_vector(3 downto 0);
signal disp_red: std_logic_vector(3 downto 0);
signal disp_green: std_logic_vector(3 downto 0);

-- Stripe block signals:
signal show_stripe: std_logic;

-- Clock divider signals:
signal i_kHz, i_hHz, i_dHz, i_pixel_clk: std_logic;

-- Sync module signals:
signal vga_blank : std_logic;
signal scan_line_x: std_logic_vector(9 downto 0);
signal scan_line_y: std_logic_vector(8 downto 0);

-- Box size signals:
signal inc_box, dec_box: std_logic;
signal box_size, size: std_logic_vector(8 downto 0);
signal letter_size: std_logic_vector(4 downto 0);

-- Bouncing box signals:
signal box_color: std_logic_vector(11 downto 0);
signal box_red: std_logic_vector(3 downto 0);
signal box_green: std_logic_vector(3 downto 0);
signal box_blue: std_logic_vector(3 downto 0);

-- ADDED
signal stripe_red: std_logic_vector(3 downto 0);
signal stripe_green: std_logic_vector(3 downto 0);
signal stripe_blue: std_logic_vector(3 downto 0);

signal d_switches: std_logic_vector(14 downto 0);
signal d_buttons: std_logic_vector(2 downto 0);

signal box_size_enable, letter_size_enable: std_logic;

begin
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
            pixel_clk => i_pixel_clk,
            blank => vga_blank,
            hor_sync => hsync,
            ver_sync => vsync,
            scan_x => scan_line_x,
            scan_y => scan_line_y
        );
    
    box_size_counter: up_down_counter
        generic map(
            width => 9
        )
        port map(
            clk => clk,
            reset => reset,
            enable => box_size_enable,
            up => inc_box,
            down => dec_box,
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
            up => inc_box,
            down => dec_box,
            value => letter_size
        );

-- ADDED	
DIVIDER: clock_divider
    Port map (  clk              => clk,
                reset            => reset,
                kHz              => i_kHz,
                twentyfive_MHz   => i_pixel_clk,
                enable           => '1',
                seconds_port     => open,
                ten_seconds_port => open,
                minutes_port     => open,
                ten_minutes_port => open,
                hHz              => i_hHz,
                dHz              => i_dHz
		  );
        
    stripes_dff: vga_stripes_dff
        port map(
            clk => clk,
            reset => reset,
            pixel_clk => i_pixel_clk,
            enable => show_stripe,
            mode => d_switches(0),
            red => stripe_red,
            green => stripe_green,
            blue => stripe_blue
        );
    
BOX: bouncing_box
    Port map ( clk         => clk,
               reset       => reset,
               scan_line_x => scan_line_x,
               scan_line_y => scan_line_y,
               box_color   => box_color,
               box_width   => size,
               box_or_letter => d_switches(14),
               kHz         => i_kHz,
               red         => box_red,
               blue        => box_blue,
               green       => box_green
           );
-- END ADDED

show_stripe <= not vga_blank;

-- BLANKING:
-- Follow this syntax to assign other colors when they are not being blanked
red <= "0000" when (vga_blank = '1') else disp_red;
-- ADDED:
blue  <= "0000" when (vga_blank = '1') else disp_blue;
green <= "0000" when (vga_blank = '1') else disp_green;

-- Connect input buttons and switches:
-- ADDED
-- These can be assigned to different switches/buttons
reset <= d_buttons(0);
box_color <= d_switches(13 downto 2);
vga_select <= d_switches(1);
inc_box <= d_buttons(1);
dec_box <= d_buttons(2);


box_size_enable <= i_hHz when (d_switches(14) = '0') else '0';
letter_size_enable <= i_dHz when (d_switches(14) = '1') else '0';
size <= ("0000" & letter_size) when (d_switches(14) = '1') else box_size;

-----------------------------------------------------------------------------
-- OUTPUT SELECTOR:
-- Select which component to display - stripes or bouncing box
selectOutput: process(box_red, box_blue, box_green, stripe_blue, stripe_red, stripe_green)
begin
	case (vga_select) is
		-- Select which input gets written to disp_red, disp_blue and disp_green
		-- ADDED
		when '0' => disp_red <= box_red; disp_blue <= box_blue; disp_green <= box_green;
		when '1' => disp_red <= stripe_red; disp_blue <= stripe_blue; disp_green <= stripe_green;
		when others => disp_red <= "0000"; disp_blue <= "0000"; disp_green <= "0000";
	end case;
end process selectOutput;
-----------------------------------------------------------------------------

end Behavioral;
