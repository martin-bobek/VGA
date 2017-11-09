library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bouncing_box is
    port(
        clk: in std_logic;
        reset: in std_logic;
        frame: in std_logic;
        scan_x: in std_logic_vector(9 downto 0);
        scan_y: in std_logic_vector(8 downto 0);
        mode: in std_logic;
        size: in std_logic_vector(7 downto 0);
        colored: out std_logic
    );
end;

architecture behavioral of bouncing_box is
    component letters 
        port(
            scale: in std_logic_vector(4 downto 0);
            x_coord: in std_logic_vector(9 downto 0);
            y_coord: in std_logic_vector(8 downto 0);
            letter: out std_logic
        );
    end component;
    
    constant height: integer := 480;
    constant width: integer := 640;
    
    signal u_scan_x, x_loc, x_max: unsigned(9 downto 0);
    signal x_letter: std_logic_vector(9 downto 0);
    signal u_scan_y, y_loc, y_max: unsigned(8 downto 0);
    signal y_letter: std_logic_vector(8 downto 0);
    signal box_w: unsigned(8 downto 0);
    signal box_h: unsigned(7 downto 0);
    signal scale: unsigned(4 downto 0);
    signal down, right: std_logic;
    signal letter: std_logic;
begin
    u_scan_x <= unsigned(scan_x);
    u_scan_y <= unsigned(scan_y);
    scale <= unsigned(size(4 downto 0));
    
    box_h <= unsigned(size) when (mode = '0') else resize(7 * scale, 8);
    box_w <= unsigned('0' & size) when (mode = '0') else resize(14 * scale, 9);
    x_letter <= std_logic_vector(u_scan_x - x_loc);
    y_letter <= std_logic_vector(u_scan_y - y_loc);
    x_max <= width - ('0' & box_w);
    y_max <= height - ('0' & box_h);
    
    letter_mask: letters
        port map(
            scale => size(4 downto 0),
            x_coord => x_letter,
            y_coord => y_letter,
            letter => letter
        );
        
    process(clk, reset) begin
        if (reset = '1') then
            x_loc <= (others => '0');
            y_loc <= (others => '0');
            down <= '1';
            right <= '1';
        elsif rising_edge(clk) and (frame = '1') then
            if (y_loc > y_max) then
                y_loc <= y_max;
                down <= '0';
            elsif (down = '1') then
                if (y_loc = y_max) then
                    down <= '0';
                else
                    y_loc <= y_loc + 1;
                end if;
            else
                if (y_loc = 0) then
                    down <= '1';
                else
                    y_loc <= y_loc - 1;
                end if;
            end if;
            
            if (x_loc > x_max) then
                x_loc <= x_max;
                right <= '0';
            elsif (right = '1') then
                if (x_loc = x_max) then
                    right <= '0';
                else
                    x_loc <= x_loc + 1;
                end if;
            else
                if (x_loc = 0) then
                    right <= '1';
                else
                    x_loc <= x_loc - 1;
                end if;
            end if;
        end if;
    end process;

    process(mode, letter, scan_x, scan_y, x_loc, y_loc, box_h, box_w) begin
        if (u_scan_x >= x_loc) and (u_scan_x < ('0' & x_loc) + box_w) and 
                (u_scan_y >= y_loc) and (u_scan_y < ('0' & y_loc) + box_h) then
            if (mode = '1') then
                colored <= letter;
            else
                colored <= '1';
            end if;
        else
            colored <= '0';
        end if;
    end process;
end;
