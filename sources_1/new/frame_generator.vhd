library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity frame_generator is
    port(
        clk: in std_logic;
        reset: in std_logic;
        kHz: in std_logic;
        scan_x: in std_logic_vector(9 downto 0);
        scan_y: in std_logic_vector(8 downto 0);
        mode: in std_logic_vector(1 downto 0);
        color: in std_logic_vector(11 downto 0);
        output: out std_logic_vector(11 downto 0)
    );
end;

architecture behavioural of frame_generator is
    component bouncing_box is
        port(
            clk: in std_logic;
            reset: in std_logic;
            kHz: in std_logic;
            scan_x: in std_logic_vector(9 downto 0);
            scan_y: in std_logic_vector(8 downto 0);
            mode: in std_logic;
            size: in std_logic_vector(8 downto 0);
            color: in std_logic_vector(11 downto 0);
            red: in std_logic_vector(3 downto 0);
            green: in std_logic_vector(3 downto 0);
            blue: in std_logic_vector(3 downto 0)
        );
    end component;
    
    component vga_stipes_dff is
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
begin

end;