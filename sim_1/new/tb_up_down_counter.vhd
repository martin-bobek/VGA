library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_up_down_counter is
end tb_up_down_counter;

architecture behavior of tb_up_down_counter is

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT up_down_counter
        Generic (   WIDTH: integer:= 6);
        Port    (
                    up: in STD_LOGIC;
                    down: in STD_LOGIC;
                    clk: in STD_LOGIC;
                    reset: in STD_LOGIC;
                    enable: in STD_LOGIC;
                    val: out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
                );
    END COMPONENT;
    
    --Inputs
    signal clk: std_logic;
    signal reset: std_logic;
    signal enable: std_logic;
    signal up: std_logic := '0';
    signal down: std_logic := '0';
    
	--Outputs
    signal val: STD_LOGIC_VECTOR(6-1 downto 0);
    
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: up_down_counter PORT MAP (
          up => up,
          down => down,
          clk => clk,
          reset => reset,
          enable => enable,
          val => val                       
        );

   -- Clock process 
   ClockProcess :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process; 

  -- Enable process
  EnableProcess :process
  begin
       enable <= '0';
       wait for clk_period*3;
       enable <= '1';
       wait for clk_period;
  end process; 
  
   -- Stimulus process
   StimulusProcess: process
   begin		
      -- hold reset state for 20 ns.
		reset <= '0';
      wait for 10 ns;	
		reset <= '1';
      wait for 20 ns;
		reset <= '0';
      wait for 10 ns;
        up <= '1';
      wait for 150 ns;
        up <= '0';
      wait for 100 ns;
        down <= '1';
      wait for 150 ns;
        down <= '0';
      wait for 100 ns;
   end process;

END;