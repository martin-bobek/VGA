library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bouncing_box is
    port( 	
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        scan_line_x: in STD_LOGIC_VECTOR(9 downto 0);
        scan_line_y: in STD_LOGIC_VECTOR(8 downto 0);
        box_color: in STD_LOGIC_VECTOR(11 downto 0);
        box_width: in STD_LOGIC_VECTOR(8 downto 0);
        box_or_letter: in STD_LOGIC;
        kHz: in STD_LOGIC;
        red: out STD_LOGIC_VECTOR(3 downto 0);
        blue: out STD_LOGIC_VECTOR(3 downto 0);
        green: out std_logic_vector(3 downto 0)
    );
end;

architecture Behavioral of bouncing_box is
component letter_b 
    port(
        scale: in std_logic_vector(4 downto 0);
        x_coord: in std_logic_vector(10 downto 0);
        y_coord: in std_logic_vector(10 downto 0);
        contained: out std_logic
    );
end component;


component mult_width
		Port (  
		        box_width   : in  std_logic_vector(8 downto 0);
		        box_width1  : out std_logic_vector(8 downto 0);
				box_width2  : out std_logic_vector(8 downto 0);
		        box_width3  : out std_logic_vector(8 downto 0);
		        box_width4  : out std_logic_vector(8 downto 0);
		        box_width5  : out std_logic_vector(8 downto 0);
		        box_width6  : out std_logic_vector(8 downto 0);
		        box_width7  : out std_logic_vector(8 downto 0);
		        box_width8  : out std_logic_vector(8 downto 0);
		        box_width9  : out std_logic_vector(8 downto 0);
		        box_width10 : out std_logic_vector(8 downto 0);
		        box_width11 : out std_logic_vector(8 downto 0);
		        box_width12 : out std_logic_vector(8 downto 0);
		        box_width13 : out std_logic_vector(8 downto 0);
		        box_width14 : out std_logic_vector(8 downto 0);
		        box_width15 : out std_logic_vector(8 downto 0);
		        box_width16 : out std_logic_vector(8 downto 0);
		        box_width17 : out std_logic_vector(8 downto 0);
		        box_width18 : out std_logic_vector(8 downto 0);
		        box_width19 : out std_logic_vector(8 downto 0)
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

signal i_box_width1  : std_logic_vector(8 downto 0);
signal i_box_width2  : std_logic_vector(8 downto 0);
signal i_box_width3  : std_logic_vector(8 downto 0);
signal i_box_width4  : std_logic_vector(8 downto 0);
signal i_box_width5  : std_logic_vector(8 downto 0);
signal i_box_width6  : std_logic_vector(8 downto 0);
signal i_box_width7  : std_logic_vector(8 downto 0);
signal i_box_width8  : std_logic_vector(8 downto 0);
signal i_box_width9  : std_logic_vector(8 downto 0);
signal i_box_width10 : std_logic_vector(8 downto 0);
signal i_box_width11 : std_logic_vector(8 downto 0);
signal i_box_width12 : std_logic_vector(8 downto 0);
signal i_box_width13 : std_logic_vector(8 downto 0);
signal i_box_width14 : std_logic_vector(8 downto 0);
signal i_box_width15 : std_logic_vector(8 downto 0);
signal i_box_width16 : std_logic_vector(8 downto 0);
signal i_box_width17 : std_logic_vector(8 downto 0);
signal i_box_width18 : std_logic_vector(8 downto 0);
signal i_box_width19 : std_logic_vector(8 downto 0);

signal contained: std_logic;

begin
widths: mult_width
	Port map(   box_width   => box_width,
				box_width1	=> i_box_width1,
		        box_width2  => i_box_width2,
		        box_width3  => i_box_width3,
		        box_width4  => i_box_width4,
		        box_width5  => i_box_width5,
		        box_width6  => i_box_width6,
		        box_width7  => i_box_width7,
		        box_width8  => i_box_width8,
		        box_width9  => i_box_width9,
		        box_width10 => i_box_width10,
		        box_width11 => i_box_width11,
		        box_width12 => i_box_width12,
		        box_width13 => i_box_width13,
		        box_width14 => i_box_width14,
		        box_width15 => i_box_width15,
		        box_width16 => i_box_width16,
		        box_width17 => i_box_width17,
		        box_width18 => i_box_width18,
		        box_width19 => i_box_width19
				);

--letters_loc_y_max <= '0' & i_box_width7;
--letters_loc_x_max <= '0' & i_box_width19;

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
B: letter_b
    port map(
        scale => box_width(4 downto 0),
        x_coord => letters_coord_x,
        y_coord => letters_coord_y,
        contained => contained
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

