library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_up_down_counter is end;

architecture behavior of tb_up_down_counter is
    component up_down_counter
        generic(
           width: integer
        );
        port(
            clk: in std_logic;
            reset: in std_logic;
            enable: in std_logic;
            up: in std_logic;
            down: in std_logic;
            value: out std_logic_vector(width - 1 downto 0)
        );
    end component;
    
    constant clk_period: time := 1 ns;
    
    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal enable: std_logic;
    signal up: std_logic := '0';
    signal down: std_logic := '0';
    signal value: std_logic_vector(5 downto 0);
begin
    uut: up_down_counter
        generic map(
            width => 6
        )
        port map(
            clk => clk,
            reset => reset,
            enable => enable,
            up => up,
            down => down,
            value => value
        );

    process begin
        enable <= '0';
        wait for clk_period*3;
        enable <= '1';
        wait for clk_period;
    end process;
  
    process begin
        wait for 3*clk_period;
        up <= '1';
        wait for 15*clk_period;
        up <= '0';
        wait for 5*clk_period;
        down <= '1';
        wait for 15*clk_period;
        down <= '0';
        wait;
    end process;   
    
    process begin
        enable <= '0';
        wait for 3*clk_period;
        enable <= '1';
        wait for clk_period;
    end process;   
    
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;