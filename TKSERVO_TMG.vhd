----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/04/28 14:32:09
-- Design Name: 
-- Module Name: TKSERVO_TMG - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- MASTER : bTMG is output / SLAVE
-- iANGLE / oSERVO : 0 : 1500us / 127 : 2200us / -127 : 800us
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TKSERVO_TMG is
generic (
	CW  : integer := 7;  -- PERI_GEN cnt Width
	CNT : integer := 109
); -- TRUE:MASTER / FALSE:SLAVE
port (
	iCLK  : in  std_logic;
	iRST  : in  std_logic;
	oTMG  : out std_logic;
	oPERI : out std_logic
);
end TKSERVO_TMG;

architecture RTL of TKSERVO_TMG is
	constant cCNT      : integer := CNT - 1;
	constant cPCNT_MAX : std_logic_vector(11 downto 0) := conv_std_logic_vector(3656,12); -- 0.02/CNT*PERI = 367

	signal rCNT  : std_logic_vector(CW-1 downto 0) := (others => '0');
	signal rPERI : std_logic                       := '0';
	signal rPCNT : std_logic_vector(11   downto 0) := (others => '0');
	signal rTMG  : std_logic                       := '0';

begin

	P_CNT : process(iCLK)
	begin
		if (iCLK'event and iCLK ='1') then
			if (iRST = '1') then
				rCNT  <= (others => '0');
				rPERI <= '0';
				rPCNT <= (others => '0');
				rTMG  <= '0';
			elsif (rCNT = conv_std_logic_vector(cCNT,CW)) then
				rCNT  <= (others => '0');
				rPERI <= '1';
				if (rPCNT = cPCNT_MAX) then
					rPCNT <= (others => '0');
					rTMG  <= '1';
				else
					rPCNT <= rPCNT + '1';
					rTMG  <= '0';
				end if;
			else
				rCNT  <= rCNT + '1';
				rPERI <= '0';
				rTMG  <= '0';
			end if;
		end if;
	end process;

	-- output
	oTMG  <= rTMG;
	oPERI <= rPERI;
	
end RTL;
