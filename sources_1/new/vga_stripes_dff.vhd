library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_stripes_dff is
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
end;

architecture behavioral of vga_stripes_dff is
    type colors is (c_white, c_yellow, c_cyan, c_green, c_magenta, c_red, c_blue, c_black);
    type states is (s0, s1, s2, s3, s4, s5, s6, s7);
    
    constant stripe_width: unsigned(6 downto 0) := to_unsigned(79, 7);
    
    signal pixel_count: unsigned(6 downto 0);
    signal color: colors;
    signal current_state, next_state: states;
    signal captured_mode: std_logic; 
begin
    process(clk, reset) begin
        if (reset = '1') then
            pixel_count <= (others => '0');
            current_state <= s0;
            captured_mode <= mode;
        elsif rising_edge(clk) and (enable = '1') and (pixel_clk = '1') then
            if (pixel_count <= stripe_width) then
                pixel_count <= (others => '0');
                current_state <= next_state;
                if (next_state = s0) then
                    captured_mode <= mode;
                end if;
            else
                pixel_count <= pixel_count + 1;
            end if;
        end if;
    end process;

    process(current_state, captured_mode) begin
        case current_state is
            when s0 =>
                color <= c_white;
                next_state <= s1;
            when s1 =>
                color <= c_yellow;
                next_state <= s2;
            when s2 =>
                color <= c_cyan;
                next_state <= s3;
            when s3 =>
                color <= c_green;
                next_state <= s4;
            when s4 => 
                color <= c_magenta;
                if (captured_mode = '1') then
                    next_state <= s6;
                else
                    next_state <= s5;
                end if;
            when s5 => 
                color <= c_red;
                if (captured_mode = '1') then
                    next_state <= s7;
                else
                    next_state <= s6;
                end if;
            when s6 => 
                color <= c_blue;
                if (captured_mode = '1') then
                    next_state <= s5;
                else
                    next_state <= s7;
                end if;
            when s7 => 
                color <= c_black;
                next_state <= s0;
        end case;
    end process;

	process(color) begin
		case color is
			when c_white     => red <= "1111"; green <= "1111"; blue <= "1111";
			when c_yellow    => red <= "1111"; green <= "1111"; blue <= "0000";
			when c_cyan      => red <= "0000"; green <= "1111"; blue <= "1111";
			when c_green     => red <= "0000"; green <= "1111"; blue <= "0000";
			when c_magenta   => red <= "1111"; green <= "0000"; blue <= "1111";
			when c_red       => red <= "1111"; green <= "0000"; blue <= "0000";
			when c_blue      => red <= "0000"; green <= "0000"; blue <= "1111";
			when c_black     => red <= "0000"; green <= "0000"; blue <= "0000";
		end case;
	end process;
end;
