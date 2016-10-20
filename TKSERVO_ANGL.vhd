----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/04/28 14:32:09
-- Design Name: 
-- Module Name: TKSERVO_ANGL - RTL
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

entity TKSERVO_ANGL is
port (
	iCLK   : in  std_logic;
	iRST   : in  std_logic;
	iTMG   : in  std_logic;
	iPERI  : in  std_logic;
	iANGLE : in  std_logic_vector(7 downto 0);
	oSERVO : out std_logic
);
end TKSERVO_ANGL;

architecture RTL of TKSERVO_ANGL is
	constant cCENTER : std_logic_vector(8 downto 0) := conv_std_logic_vector(273,9);
	signal rANGLE    : std_logic_vector(8 downto 0) := (others => '0');
	signal rCNT      : std_logic_vector(8 downto 0) := (others => '0');
	signal rSERVO    : std_logic                    := '0';
begin

	P_LATCH : process(iCLK)
	begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rANGLE <= (others => '0');
			elsif(iTMG = '1') then
				rANGLE <= cCENTER + (iANGLE(7) & iANGLE);
			--	rANGLE <= cCENTER + gANGLE;
			end if;
		end if;
	end process;

	P_CNT : process(iCLK)
	begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rCNT   <= (others => '0');
				rSERVO <= '0';
			elsif(iTMG = '1') then
				rCNT <= (others => '0');
				rSERVO <= '1';
			elsif(iPERI = '1') then
				if (rCNT = rANGLE) then
					rSERVO <= '0';
				else
					rCNT <= rCNT + '1';
				end if;
			end if;
		end if;
	end process;

	-- output
	oSERVO <= rSERVO;

end RTL;
