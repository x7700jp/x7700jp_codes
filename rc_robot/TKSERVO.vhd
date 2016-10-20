----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/04/28 14:32:09
-- Design Name: 
-- Module Name: TKSERVO - RTL
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

entity TKSERVO is
generic (
	MASTER : boolean := TRUE; -- TRUE:MASTER / FALSE:SLAVE
	CW     : integer := 4   ; -- PERI_GEN cnt Width
	CNT    : integer := 11
);
port (
	iCLK   : in    std_logic;
	iRST   : in    std_logic;
	iANGLE : in    std_logic_vector (7 downto 0);
	bTMG   : inout std_logic; -- MASTER TRUE : output / FALSE : input
	bPERI  : inout std_logic; -- MASTER TRUE : output / FALSE : input
	oSERVO : out   std_logic
);
end TKSERVO;

architecture RTL of TKSERVO is
	component TKSERVO_TMG
	generic (
		CW  : integer := 7;  -- PERI_GEN cnt Width
		CNT : integer := 109
	);
	port(
		iCLK  : in  std_logic;
		iRST  : in  std_logic;
		oTMG  : out std_logic;
		oPERI : out std_logic
	);
	end component;

	component TKSERVO_ANGL
	port(
		iCLK   : in  std_logic;
		iRST   : in  std_logic;
		iTMG   : in  std_logic;
		iPERI  : in  std_logic;
		iANGLE : in  std_logic_vector(7 downto 0);
		oSERVO : out std_logic
	);
	end component;

	signal sTMG   : std_logic;
	signal sPERI  : std_logic;
	signal sSERVO : std_logic;

begin
	G_GEN1 : if (MASTER = TRUE) generate
		U_TMG_GEN : TKSERVO_TMG
		generic map(
			CW  => CW  ,  -- PERI_GEN cnt Width
			CNT => CNT
		)
		port map(
			iCLK  => iCLK ,
			iRST  => iRST ,
			oTMG  => sTMG ,
			oPERI => sPERI
		);

		bTMG  <= sTMG;
		bPERI <= sPERI;
	end generate;

	G_GEN2 : if (MASTER = FALSE) generate
		sTMG  <= bTMG ; bTMG  <= 'Z';
		sPERI <= bPERI; bPERI <= 'Z';
	end generate;

	U_ANGL : TKSERVO_ANGL
	port map(
		iCLK   => iCLK   ,
		iRST   => iRST   ,
		iTMG   => sTMG   ,
		iPERI  => sPERI  ,
		iANGLE => iANGLE ,
		oSERVO => sSERVO
	);

	-- output
	oSERVO <= sSERVO;

end RTL;
