library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity up_down_counter is
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
end;

architecture behavioral of up_down_counter is
    signal u_value: unsigned(width - 1 downto 0);
begin
    value <= std_logic_vector(u_value);

    process(clk, reset) begin
        if (reset = '1') then
            u_value <= (others => '0');
        elsif rising_edge(clk) and (enable = '1') then
            if (up = '1') then
                u_value <= u_value + 1;
            elsif (down = '1') then
                u_value <= u_value - 1;
            end if;
        end if;
    end process;
end;
