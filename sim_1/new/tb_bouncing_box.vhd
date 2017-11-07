library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_bouncing_box is end;

architecture behavior of tb_bouncing_box is
    component bouncing_box is
        port(
            clk: in std_logic;
            reset: in std_logic;
            kHz: in std_logic;
            scan_x: in std_logic_vector(9 downto 0);
            scan_y: in std_logic_vector(8 downto 0);
            mode: in std_logic;
            size: in std_logic_vector(8 downto 0);
            colored: out std_logic
        );
    end component;
    
    constant clk_period: time := 1ns;
    
    signal clk, reset: std_logic := '1';
    signal kHz: std_logic;
    signal scan_x: std_logic_vector(9 downto 0) := "1000000001";
    signal scan_y: std_logic_vector(8 downto 0) := "000000001";
    signal mode: std_logic := '1';
    signal size: std_logic_vector(8 downto 0) := "100001000";
    signal colored: std_logic;
begin
    uut: bouncing_box
        port map(
            clk => clk,
            reset => reset,
            kHz => kHz,
            scan_x => scan_x,
            scan_y => scan_y,
            mode => mode,
            size => size,
            colored => colored
        );
        
    process begin
        kHz <= '1';
        wait for clk_period;
        kHz <= '0';
        wait for clk_period * 10;
    end process;

    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;
