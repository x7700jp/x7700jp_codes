----------------------------------------------------------------------------------
-- Create Date:    2016.07.18
-- Design Name:    WRAP_RCV_OUT
-- Module Name:    WRAP_RCV_OUT - RTL 
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

entity WRAP_RCV_OUT is
generic(
	CH     : integer := 0   ; -- ch 0 to 3
	MASTER : boolean := True  -- master:true / slave:false
);
port (
	iCLK     : in    std_logic;
	iRST     : in    std_logic;
	iRCV     : in    std_logic;
	bTMG     : inout std_logic; -- master:out / slave:in
	oOUT_LH  :   out std_logic;
	oOUT_RH  :   out std_logic;
	oxOUT_LL :   out std_logic;
	oxOUT_RL :   out std_logic
);
end WRAP_RCV_OUT;


architecture RTL of WRAP_RCV_OUT is

	-- user logic
	component TKRCV
	generic (
		CW       : integer := 7   ; -- PERI_GEN cnt Width
		CNT      : integer := 94    -- 1.4ms/256/clk_peri
	);
	port (
		iCLK  : in    std_logic;
		iRST  : in    std_logic;
		iRCV  : in    std_logic;
		oRCV  : out   std_logic_vector(7 downto 0)
	);
	end component;

	component PWM_CURV
	generic(
		CH     : integer := 0   ; -- ch 0 to 3
		MASTER : boolean := True  -- master:true / slave:false
	);
	port(
		iCLK   : in    std_logic;
		iRST   : in    std_logic;
		iRCV_D : in  std_logic_vector(7 downto 0);
		bTMG   : inout std_logic; -- master:out / slave:in
		oPWM   :   out std_logic;
		oCTRL  :   out std_logic_vector(1 downto 0)
	);
	end component;

	component PTN_GEN
	port(
		iCLK     : in  std_logic;
		iRST     : in  std_logic;
		iPWM     : in  std_logic;
		iCTRL    : in  std_logic_vector(1 downto 0);
		oOUT_LH  : out std_logic;
		oOUT_RH  : out std_logic;
		oxOUT_LL : out std_logic;
		oxOUT_RL : out std_logic
	);
	end component;

	-- signal
	signal sRCV     : std_logic_vector(7 downto 0);
	signal sPWM     : std_logic;
	signal sCTRL    : std_logic_vector(1 downto 0);
	signal sPTN     : std_logic;
	signal sOUT_RH  : std_logic;
	signal sOUT_LH  : std_logic;
	signal sxOUT_RL : std_logic;
	signal sxOUT_LL : std_logic;

begin
	
	U_RCV : TKRCV
	generic map(
		CW       => 6  ,  -- PERI_GEN cnt Width
		CNT      => 56     -- 1.4ms/256/(1/10.23M)
	)
	port map(
		iCLK => iCLK   ,
		iRST => iRST   ,
		iRCV => iRCV   ,
		oRCV => sRCV
	);
	
	U_PWM_CURV : PWM_CURV
	generic map(
		CH     => CH     ,
		MASTER => MASTER
	)
	port map(
		iCLK   => iCLK ,
		iRST   => iRST ,
		iRCV_D => sRCV ,
		bTMG   => bTMG ,
		oPWM   => sPWM ,
		oCTRL  => sCTRL
	);

	U_PTN : PTN_GEN
	port map(
		iCLK     => iCLK     ,
		iRST     => iRST     ,
		iPWM     => sPWM     ,
		iCTRL    => sCTRL    ,
		oOUT_LH  => sOUT_LH  ,
		oOUT_RH  => sOUT_RH  ,
		oxOUT_LL => sxOUT_LL ,
		oxOUT_RL => sxOUT_RL
	);

	-- output
	oOUT_LH  <= sOUT_LH;
	oOUT_RH  <= sOUT_RH;
	oxOUT_LL <= sxOUT_LL;
	oxOUT_RL <= sxOUT_RL;

end RTL;
