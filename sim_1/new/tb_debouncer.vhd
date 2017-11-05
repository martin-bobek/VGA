library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debouncer is end;

architecture behavioural of tb_debouncer is
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
    
    constant clk_period: time := 1ns;
    
    signal clk: std_logic := '1';
    signal input, output: std_logic;
begin
    uut: debouncer
        generic map(
            period => 10,
            width => 4
        )
        port map(
            clk => clk,
            input => input,
            output => output
        );
    
    process begin
        input <= '1';
        wait for clk_period;
        input <= '0';
        wait for 20*clk_period;
        input <= '1';
        wait for 5*clk_period;
        input <= '0';
        wait for 2*clk_period;
        input <= '1';
        wait for 15*clk_period;
        input <= '0';
        wait for 10*clk_period;
        input <= '1';
        wait;
    end process;
    
    clk <= not clk after clk_period/2;
end;