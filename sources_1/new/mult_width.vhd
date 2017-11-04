library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mult_width is
		Port (  box_width   : in  std_logic_vector(8 downto 0);
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
end mult_width;

architecture Behavioral of mult_width is
    signal  w1, w2, w3, w4, w5 :      std_logic_vector(8 downto 0); 
    signal  w6, w7, w8, w9, w10 : std_logic_vector(8 downto 0);


begin

process(box_width, w1) begin

	if (box_width > "000100000") then
		w1 <= "000100000";
--    elsif (box_width < "000000010") then
--        w1 <= "000000001";
    elsif (box_width < "000000000") then
         w1 <= "000000000";
	else
		w1 <= box_width;
	end if;
	
end process;

w2  <= w1 + w1;
w3  <= w1 + w2;
w4  <= w2 + w2;
w5  <= w2 + w3;
w6  <= w3 + w3;
w7  <= w3 + w4;
w8  <= w4 + w4;
w9  <= w4 + w5;
w10 <= w5 + w5;

box_width1  <= w1;
box_width2  <= w2;
box_width3  <= w3;
box_width4  <= w4;
box_width5  <= w5;
box_width6  <= w6;
box_width7  <= w7;
box_width8  <= w8;
box_width9  <= w9;
box_width10 <= w10;
box_width11 <= w9 + w2;
box_width12 <= w10 + w2;
box_width13 <= w10 + w3; 
box_width14 <= w10 + w4;
box_width15 <= w10 + w5;
box_width16 <= w10 + w6;
box_width17 <= w10 + w7;
box_width18 <= w10 + w8;
box_width19 <= w10 + w9;

end Behavioral;