----------------------------------------------------------------------------------
-- Create Date:    2016.07.18
-- Design Name:    PTN_GEN
-- Module Name:    PTN_GEN - RTL 
-- Project Name:   TK_AMP
-- Target Devices: LCMXO2-1200HC4-TG100C
-- Tool versions:  Lattice diamond 3.7.0.96.1
-- Description:    RC Speed Controler
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PTN_GEN is
port (
	iCLK     : in  std_logic;
	iRST     : in  std_logic;
	iPWM     : in  std_logic;
	iCTRL    : in  std_logic_vector(1 downto 0);
	oOUT_LH  : out std_logic;
	oOUT_RH  : out std_logic;
	oxOUT_LL : out std_logic;
	oxOUT_RL : out std_logic
);
end PTN_GEN;


architecture RTL of PTN_GEN is

	-- signal
	signal gOUT_LH  : std_logic ;
	signal gOUT_RH  : std_logic ;
	signal gOUT_LL  : std_logic ;
	signal gOUT_RL  : std_logic ;
	signal rOUT_LH  : std_logic := '0';
	signal rOUT_RH  : std_logic := '0';
	signal rxOUT_LL : std_logic := '1';
	signal rxOUT_RL : std_logic := '1';
	


begin

	-- gate
	gOUT_LH <=     '0'  when(iCTRL = "11") else
	               '0'  when(iCTRL = "10") else
	               iPWM when(iCTRL = "01") else
	               '0'  ;

	gOUT_LL <=     iPWM when(iCTRL = "11") else
	               iPWM when(iCTRL = "10") else
	           not iPWM when(iCTRL = "01") else
	               '0'  ;

	gOUT_RH <=     '0'  when(iCTRL = "11") else
	               iPWM when(iCTRL = "10") else
	               '0'  when(iCTRL = "01") else
	               '0'  ;

	gOUT_RL <=     iPWM when(iCTRL = "11") else
	           not iPWM when(iCTRL = "10") else
	               iPWM when(iCTRL = "01") else
	               '0'  ;

	-- FF
	P_FF : process(iCLK)
	begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rOUT_LH  <= '0';
				rOUT_RH  <= '0';
				rxOUT_LL <= '1';
				rxOUT_RL <= '1';
			else
				rOUT_LH  <=     gOUT_LH ;
				rOUT_RH  <=     gOUT_RH ;
				rxOUT_LL <= not gOUT_LL ;
				rxOUT_RL <= not gOUT_RL ;
			end if;
		end if;
	end process;

	-- output
	oOUT_LH  <= rOUT_LH ;
	oOUT_RH  <= rOUT_RH ;
	oxOUT_LL <= rxOUT_LL;
	oxOUT_RL <= rxOUT_RL;

end RTL;