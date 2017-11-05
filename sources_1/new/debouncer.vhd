library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    generic(
        period: integer;
        width: integer
    );
    port(
        clk:in std_logic;
        input:in std_logic;
        output:out std_logic
    );
end;

architecture behavioural of debouncer is
    constant top: unsigned(width - 1 downto 0) := to_unsigned(period - 1, width);

    signal hold: std_logic_vector(1 downto 0);
    signal counter: unsigned(width - 1 downto 0);
    signal counter_reset, match: std_logic;
begin
    counter_reset <= hold(0) xor hold(1);
    match <= '1' when (counter = top) else '0';
    
    process(clk) begin
        if rising_edge(clk) then
            hold(0) <= input;
            hold(1) <= hold(0);
            if (match = '1') then
                output <= hold(1);
            end if; 
        end if;
    end process;
    
    process(clk) begin
        if rising_edge(clk) then
            if (counter_reset = '1') then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end;
