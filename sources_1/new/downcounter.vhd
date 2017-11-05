library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity downcounter is
    generic(
        period: integer;
        width: integer
    );
    port(
        clk: in std_logic;
        reset: in std_logic;
        enable: in std_logic;
        zero: out std_logic;
        value: out std_logic_vector(width - 1 downto 0)
    );
end;

architecture behavioural of downcounter is
    constant top: unsigned(width - 1 downto 0) := to_unsigned(period - 1, width);
    constant zeros: unsigned(width - 1 downto 0) := (others => '0');
    
    signal counter: unsigned(width - 1 downto 0);
    signal i_zero: std_logic;
begin
    value <= std_logic_vector(counter);
    zero <= i_zero;
    
    process(clk, reset) begin
        if (reset = '1') then
            counter <= top;
            i_zero <= '0';
        elsif rising_edge(clk) then
            if (enable = '1') then
                if (counter = zeros) then
                    counter <= top;
                    i_zero <= '1';
                else
                    counter <= counter - 1;
                end if;
            end if;
            
            if (i_zero = '1') then
                i_zero <= '0';
            end if;
        end if;
    end process;
end;
