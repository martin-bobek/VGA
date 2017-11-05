library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sync_signal_generator is end;

architecture behaviour of tb_sync_signal_generator is
    component sync_signal_generator is
        port(
            clk: in std_logic;
            reset: in std_logic;
            pixel_clk: in std_logic;
            blank: out std_logic;
            hor_sync: out std_logic;
            ver_sync: out std_logic;
            scan_x: out std_logic_vector(9 downto 0);
            scan_y: out std_logic_vector(8 downto 0)
        );
    end component;
    
    constant clk_period: time := 1 ns;
    
    signal clk, reset: std_logic := '1';
    signal pixel_clk: std_logic;
    signal blank: std_logic;
    signal hor_sync, ver_sync: std_logic;
    signal scan_x: std_logic_vector(9 downto 0);
    signal scan_y: std_logic_vector(8 downto 0);
begin
    uut: sync_signal_generator
        port map(
            clk => clk,
            reset => reset,
            pixel_clk => pixel_clk,
            blank => blank,
            hor_sync => hor_sync,
            ver_sync => ver_sync,
            scan_x => scan_x,
            scan_y => scan_y
        );
    
    process begin
        pixel_clk <= '1';
        wait for clk_period;
        pixel_clk <= '0';
        wait for 3*clk_period;
    end process;
    
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;
