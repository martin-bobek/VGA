library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debouncer is end;

architecture behavioural of tb_debouncer is
    component debouncer is
        generic(
            period: integer := 50;
            width: integer := 5
        );
        port(
            clk:in std_logic;
            input:in std_logic;
            result:out std_logic
        );
    end component;
    
    constant clk_period: time := 20ns;
    
    signal clk, input, result: std_logic;
begin
    uut: debouncer
        generic map(
            period => 10,
            width => 4
        )
        port map(
            clk => clk,
            input => input,
            result => result
        );
        
    clk_proc: process begin
        clk <= '1';
        wait for clk_period / 2;
        clk <= '0';
        wait for clk_period / 2;
    end process;
    
    stim_proc: process begin
        input <= '0';
        wait for 20 * clk_period;
        input <= '1';
        wait for 5 * clk_period;
        input <= '0';
        wait for 2 * clk_period;
        input <= '1';
        wait for 15 * clk_period;
        input <= '0';
        wait for 11 * clk_period;
        input <= '1';
        wait;
    end process;
end;