library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sync_signal_generator is
    port(
        clk: in std_logic;
        reset: in std_logic;
        pixel_clk: in std_logic;
        frame: out std_logic;
        blank: out std_logic;
        hor_sync: out std_logic;
        ver_sync: out std_logic;
        scan_x: out std_logic_vector(9 downto 0);
        scan_y: out std_logic_vector(8 downto 0)
    );
end;

architecture behavioral of sync_signal_generator is
    constant h_disp_time: integer := 640;
    constant h_sync_pulse: integer := 800;
    constant h_back_porch: integer := 48;
    constant h_pulse_width: integer := 96;
    constant v_disp_time: integer := 480;
    constant v_sync_pulse: integer := 521;
    constant v_back_porch: integer := 29;
    constant v_pulse_width: integer := 2;
        
    signal hor_pos, ver_pos: unsigned(9 downto 0);
    signal hor_blank, ver_blank, i_blank, i_frame: std_logic;
begin
    blank <= i_blank;
    frame <= i_frame;
    hor_sync <= '0' when (hor_pos < h_pulse_width) else '1';
    ver_sync <= '0' when (ver_pos < v_pulse_width) else '1';
    
    hor_blank <= '0' when (hor_pos + 1 >= h_pulse_width + h_back_porch) and
                          (hor_pos + 1 < h_pulse_width + h_back_porch + h_disp_time) else '1';
    ver_blank <= '0' when (ver_pos >= v_pulse_width + v_back_porch) and
                          (ver_pos < v_pulse_width + v_back_porch + v_disp_time) else '1';
    i_blank <= hor_blank or ver_blank;
    scan_x <= std_logic_vector(hor_pos + 1 - h_pulse_width - h_back_porch) when (i_blank = '0') else (others => '0');
    scan_y <= std_logic_vector(resize(ver_pos - v_pulse_width - v_back_porch, 9)) when (i_blank = '0') else (others => '0');
    
    process(clk, reset) begin
        if (reset = '1') then
            i_frame <= '1';
            hor_pos <= (others => '0');
            ver_pos <= (others => '0');
        elsif rising_edge(clk) then
            if (pixel_clk = '1') then
                if (hor_pos + 1 = h_sync_pulse) then
                    if (ver_pos + 1 = v_sync_pulse) then
                        ver_pos <= (others => '0');
                        i_frame <= '1';
                    else
                        ver_pos <= ver_pos + 1;
                    end if;
                    
                    hor_pos <= (others => '0');
                else
                    hor_pos <= hor_pos + 1;
                end if;
            end if;
            
            if (i_frame = '1') then
                i_frame <= '0';
            end if;
        end if;
    end process;
end;
