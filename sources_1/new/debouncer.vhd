library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    generic(
        period: integer := 50;
        width: integer := 5
    );
    port(
        clk:in std_logic;
        input:in std_logic;
        result:out std_logic
    );
end;

architecture behavioural of debouncer is
    component up_down_counter is
        generic(
            width: integer := 6
        );
        port(
            up: in std_logic;
            down: in std_logic;
            clk: in std_logic;
            reset: in std_logic;
            enable: in std_logic;
            val: out std_logic_vector(width - 1 downto 0)
        );
    end component;

    constant top_value: std_logic_vector(width - 1 downto 0) := std_logic_vector(to_unsigned(period - 1, width));

    signal q: std_logic_vector(1 downto 0);
    signal counter_reset, match, not_match: std_logic;
    signal counter_value: std_logic_vector(width - 1 downto 0);
begin
    counter: up_down_counter
        generic map(
            width => width
        )
        port map(
            up => '1',
            down => '0',
            clk => clk,
            reset => counter_reset,
            enable => not_match,
            val => counter_value
        );

    flipflops: process(clk) begin
        if rising_edge(clk) then
            q(0) <= input;
            q(1) <= q(0);
            if (match = '1') then
                result <= q(1);
            end if;
        end if;
    end process;
    
    counter_reset <= q(0) xor q(1);
    match <= '1' when (counter_value = top_value) else '0';
    not_match <= not match;
end;