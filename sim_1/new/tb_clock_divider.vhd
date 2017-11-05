library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock_divider is end;

architecture behavioural of tb_clock_divider is
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

    constant clk_period: time := 1ns;

    signal clk, reset: std_logic := '1';
    signal twentyfive_MHz, kHz, hHz, dHz: std_logic;
begin
    uut: clock_divider
        port map(
            clk => clk,
            reset => reset,
            twentyfive_MHz => twentyfive_MHz,
            kHz => kHz,
            hHz => hHz,
            dHz => dHz
        );
    
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;
