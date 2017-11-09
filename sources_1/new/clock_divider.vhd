library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
    port(
        clk: in std_logic;
        reset: in std_logic;
        twentyfive_MHz: out std_logic;
        hHz: out std_logic;
        dHz: out std_logic
    );
end;

architecture behavioural of clock_divider is
    component downcounter is
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
    end component;

    signal i_twentyfive_MHz, i_hHz: std_logic;
begin
    twentyfive_MHz <= i_twentyfive_MHz;
    hHz <= i_hHz;
    
    clock1: downcounter
        generic map(
            period => 4,
            width => 2
        )
        port map(
            clk => clk,
            reset => reset,
            enable => '1',
            zero => i_twentyfive_MHz,
            value => open
        );

    clock2: downcounter
        generic map(
            period => 250000,
            width => 18
        )
        port map(
            clk => clk,
            reset => reset,
            enable => i_twentyfive_MHz,
            zero => i_hHz,
            value => open
        );
    
    clock4: downcounter
        generic map(
            period => 10,
            width => 4
        )
        port map(
            clk => clk,
            reset => reset,
            enable => i_hHz,
            zero => dHz,
            value => open
        );
end;
