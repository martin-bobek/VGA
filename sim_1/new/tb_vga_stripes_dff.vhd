library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_vga_stripes_dff is end;

architecture behaviour of tb_vga_stripes_dff is
    component vga_stripes_dff
        port(
            clk: in std_logic;
            reset: in std_logic;
            pixel_clk: in std_logic;
            enable: in std_logic;
            mode: in std_logic;
            red: out std_logic_vector(3 downto 0);
            green: out std_logic_vector(3 downto 0);
            blue: out std_logic_vector(3 downto 0)
        );
    end component;

    constant clk_period: time := 1ns;

    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal pixel_clk: std_logic;
    signal enable: std_logic := '1'; 
    signal mode: std_logic;
    signal red, green, blue: std_logic_vector (3 downto 0);
begin
    uut: vga_stripes_dff
        port map(
            clk => clk,
            reset => reset,
            pixel_clk => pixel_clk,
            enable => enable,
            mode => mode,
            red => red,
            green => green,
            blue => blue
        );
    
    process begin
        mode <= '0';
        wait for 4*640*clk_period;
        mode <= '1';
        wait for 4*640*clk_period;
        enable <= '0';
        wait for 4*200*clk_period;
        enable <= '1';
    end process;
  
    process begin
        pixel_clk <= '1';
        wait for clk_period;
        pixel_clk <= '0';
        wait for 3*clk_period;
    end process;
  
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;
