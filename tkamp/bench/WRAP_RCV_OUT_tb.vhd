
-- VHDL Test Bench Created from source file WRAP_RCV_OUT.vhd -- Tue Jul 19 19:19:54 2016

--
-- Notes: 
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Lattice recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "source->import"
-- menu in the ispLEVER Project Navigator to import the testbench.
-- Then edit the user defined section below, adding code to generate the 
-- stimulus for your design.
-- 3) VHDL simulations will produce errors if there are Lattice FPGA library 
-- elements in your design that require the instantiation of GSR, PUR, and
-- TSALL and they are not present in the testbench. For more information see
-- the How To section of online help.  
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture behavior of testbench is 

	component WRAP_RCV_OUT
	generic(
		CH     : integer := 0   ; -- ch 0 to 3
		MASTER : boolean := True  -- master:true / slave:false
	);
	port(
		iCLK     : in    std_logic;
		iRST     : in    std_logic;
		iRCV     : in    std_logic;    
		bTMG     : inout std_logic;      
		oOUT_LH  : out   std_logic;
		oOUT_RH  : out   std_logic;
		oxOUT_LL : out   std_logic;
		oxOUT_RL : out   std_logic
		);
	end component;

	signal rCLK     :  std_logic := '0';
	signal rRST     :  std_logic := '1';
	signal rRCV     :  std_logic := '0';

	constant cCLK_PERI : time := 1 us / 10 ;

begin

-- Please check and add your generic clause manually
	UUT: WRAP_RCV_OUT
	generic map(
		CH     => 0 ,
		MASTER => TRUE
	)
	port map(
		iCLK     => rCLK    ,
		iRST     => rRST    ,
		iRCV     => rRCV    ,
		bTMG     => open    ,
		oOUT_LH  => open    ,
		oOUT_RH  => open    ,
		oxOUT_LL => open    ,
		oxOUT_RL => open    
	);


-- *** Test Bench - User Defined Section ***
	P_CLK_GEN : process
	begin
		rCLK <= '0' ; wait for cCLK_PERI/2;
		rCLK <= '1' ; wait for cCLK_PERI/2;
	end process;

	P_RST_GEN : process
	begin
		rRST <= '1' ; wait for cCLK_PERI*100;
		rRST <= '0' ; wait ;
	end process;

	P_RCV_GEN : process
	begin
		rRCV <= '0'; wait for 100 us;
		rRCV <= '1'; wait for 1500 us; rRCV <= '0'; wait for 3 ms;
		rRCV <= '1'; wait for 1000 us; rRCV <= '0'; wait for 3 ms;
		rRCV <= '1'; wait for 2000 us; rRCV <= '0'; wait for 3 ms;
		rRCV <= '1'; wait for  800 us; rRCV <= '0'; wait for 3 ms;
		rRCV <= '1'; wait for 2200 us; rRCV <= '0'; wait for 3 ms;
	end process;



-- *** End Test Bench - User Defined Section ***

end;
