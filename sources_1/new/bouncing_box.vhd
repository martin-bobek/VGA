library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bouncing_box is
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

signal redraw: std_logic_vector(5 downto 0):=(others=>'0');
constant box_loc_x_min: std_logic_vector(9 downto 0) := "0000000000";
constant box_loc_y_min: std_logic_vector(9 downto 0) := "0000000000";
signal box_loc_x_max: std_logic_vector(9 downto 0); -- Not constants because these dependant on box_width 
signal box_loc_y_max: std_logic_vector(9 downto 0);
signal pixel_color: std_logic_vector(11 downto 0);
signal box_loc_x, box_loc_y: std_logic_vector(9 downto 0);
signal box_move_dir_x, box_move_dir_y: std_logic;

--letters 
signal letters_loc_x, letters_loc_y: std_logic_vector(9 downto 0);
signal letters_coord_x, letters_coord_y: std_logic_vector(10 downto 0);
constant letters_loc_x_min: std_logic_vector(9 downto 0) := "0000000000";
constant letters_loc_y_min: std_logic_vector(9 downto 0) := "0000000000";
signal letters_loc_x_max: std_logic_vector(9 downto 0); -- Not constants because these dependant on box_width 
signal letters_loc_y_max: std_logic_vector(9 downto 0);
signal letters_move_dir_x, letters_move_dir_y: std_logic;

signal contained: std_logic;

begin
    process(clk, reset) begin
        if (reset = '1') then
            
        elsif rising_edge(clk) then
        
        end if;
    end process;

MoveBox: process(clk, reset)
begin	
    
    if (reset ='1') then
        box_loc_x <= "0111000101";
        box_loc_y <= "0001100010";
        box_move_dir_x <= '0';
        box_move_dir_y <= '0';
        letters_loc_x <= "0111000101";
        letters_loc_y <= "0001100010";
        letters_move_dir_x <= '0';
        letters_move_dir_y <= '0';
        redraw <= (others=>'0');
    elsif (rising_edge(clk)) then
        if (box_or_letter = '0') then
            if (kHz = '1') then
                redraw <= redraw + 1;
                if (redraw = "10000") then 		-- Determines the box's speed
                    redraw <= (others => '0');
                    if box_move_dir_x <= '0' then   -- Box moving right
                        if (box_loc_x < box_loc_x_max) then -- Has not hit right wall
                            box_loc_x <= box_loc_x + 1;
                        else 
                            box_move_dir_x <= '1';	-- Box is now moving left
                        end if;
                    else
                        if (box_loc_x > box_loc_x_min) then
                            box_loc_x <= box_loc_x - 1; -- Has not hit left wall
                        else 
                            box_move_dir_x <= '0';	-- Box is now moving right
                        end if;
                    end if;
                    
                    -- Complete the Y-axis motion description here
                    -- It is very similar to X-axis motion
                    -- ADDED
                    if box_move_dir_y <= '0' then   -- Box moving down
                        if (box_loc_y < box_loc_y_max) then -- Has not hit bottom wall
                            box_loc_y <= box_loc_y + 1;
                        else 
                            box_move_dir_y <= '1';    -- Box is now moving up
                        end if;
                    else
                        if (box_loc_y > box_loc_y_min) then
                            box_loc_y <= box_loc_y - 1; -- Has not hit top wall
                        else 
                            box_move_dir_y <= '0';    -- Box is now moving down
                        end if;
                    end if;
                    -- End ADDED					
                end if;
            end if;
        elsif(box_or_letter = '1') then -- when we want the letters
            if (kHz = '1') then
                redraw <= redraw + 1;
                if (redraw = "10000") then         -- Determines the box's speed
                    redraw <= (others => '0');
                    if letters_move_dir_x <= '0' then   -- Box moving right
                        if (letters_loc_x < letters_loc_x_max) then -- Has not hit right wall
                            letters_loc_x <= letters_loc_x + 1;
                        else 
                            letters_move_dir_x <= '1';    -- Box is now moving left
                        end if;
                    else
                        if (letters_loc_x > letters_loc_x_min) then
                            letters_loc_x <= letters_loc_x - 1; -- Has not hit left wall
                        else 
                            letters_move_dir_x <= '0';    -- Box is now moving right
                        end if;
                    end if;
                    
                    -- Complete the Y-axis motion description here
                    -- It is very similar to X-axis motion
                    -- ADDED
                    if letters_move_dir_y <= '0' then   -- Box moving down
                        if (letters_loc_y < letters_loc_y_max) then -- Has not hit bottom wall
                            letters_loc_y <= letters_loc_y + 1;
                        else 
                            letters_move_dir_y <= '1';    -- Box is now moving up
                        end if;
                    else
                        if (letters_loc_y > letters_loc_y_min) then
                            letters_loc_y <= letters_loc_y - 1; -- Has not hit top wall
                        else 
                            letters_move_dir_y <= '0';    -- Box is now moving down
                        end if;
                    end if;
                    -- End ADDED                    
                end if;
            end if;
        end if;	
    end if;
end process MoveBox;

boxorletter: process(box_or_letter, scan_line_x, scan_line_y, box_loc_x, box_loc_y, letters_loc_x, letters_loc_y, box_color)
begin

    case box_or_letter is
        when '0' =>
        --pixel_color <=  box_color when  
        
                              if        ((scan_line_x >= box_loc_x) and 
                                        (scan_line_y >= box_loc_y) and 
                                        (scan_line_x < box_loc_x+box_width) and 
                                        (scan_line_y < box_loc_y+box_width)) 
                                        then
                                        pixel_color <= box_color;
                              else
                                        pixel_color <= "111111111111"; -- represents WHITE
                              end if;          
        when '1' =>
             -- row 1      
                           if ((unsigned(scan_line_x) >= unsigned(letters_loc_x)) and (unsigned(scan_line_y) >= unsigned(letters_loc_y)) and (contained = '1'))
						   then
						            pixel_color <= box_color;			                                            
                           else
                                    pixel_color <= "111111111111"; -- represents WHITE    
                           end if;
            when others =>
                                    pixel_color <= "000000000000"; -- black
    end case;
end process;
B: letters
    port map(
        scale => box_width(4 downto 0),
        x_coord => letters_coord_x(9 downto 0),
        y_coord => letters_coord_y(8 downto 0),
        letter => contained
    );
             
    red   <= pixel_color(11 downto 8);
    green <= pixel_color(7 downto 4);
    blue  <= pixel_color(3 downto 0);
    
--pixel_color <= box_color when (contained = '1') else "111111111111";

letters_coord_x <= scan_line_x - letters_loc_x;
letters_coord_y <= scan_line_y - letters_loc_y;

box_loc_x_max <= "1010000000" - box_width - 1;
-- Describe the value for box_loc_y_max here:
-- Hint: In binary, 640 is 1010000000 and 480 is 0111100000
-- ADDED
box_loc_y_max <= "0111100000" - box_width - 1;

letters_loc_x_max <= "1010000000" - i_box_width14 - 1;

letters_loc_y_max <= "0111100000" - i_box_width7 - 1;

end Behavioral;

