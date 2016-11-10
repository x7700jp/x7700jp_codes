-- Engineer: 
-- 
-- Create Date: 2016/04/28 14:32:09
-- Design Name: 
-- Module Name: PWM_CURV - RTL
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
-- 本マクロはRC信号をPWM信号、回転方向＆ブレーキ信号へ変換する
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BENCH_PWM_CURV is
end BENCH_PWM_CURV;

architecture SIM of BENCH_PWM_CURV is


	component PWM_CURV
	generic(
		CH     : integer := 0   ; -- ch 0 to 3
		MASTER : boolean := True  -- master:true / slave:false
	);
	port (
		iCLK   : in    std_logic;
		iRST   : in    std_logic;
		iRCV_D : in  std_logic_vector(7 downto 0);
		bTMG   : inout std_logic; -- master:out / slave:in
		oPWM   :   out std_logic;
		oCTRL  :   out std_logic_vector(1 downto 0)
	);
	end component;

	type tCTRL is array (0 to 3) of std_logic_vector(1 downto 0);
	signal rCLK   : std_logic                    := '0';
	signal rRST   : std_logic                    := '1';
	signal rRCV_D : std_logic_vector(7 downto 0) := (others => '0');
	signal rRCV   : std_logic_vector(7 downto 0) := (others => '0');
	signal sTMG   : std_logic;
	signal sPWM   : std_logic_vector(3 downto 0);
	signal rCTRL  : tCTRL;

	constant cCLK_PERI : time := 1 ns / 10 ; -- 

begin

--	DUTx : PWM_CURV generic map(CH, MASTER) port map(iCLK,iRST,iRCV_D,bTMG,oPWM,oCTRL);
	DUT0 : PWM_CURV generic map(0 , TRUE  ) port map(rCLK,rRST,rRCV_D,sTMG,sPWM(0),rCTRL(0));
	DUT1 : PWM_CURV generic map(1 , FALSE ) port map(rCLK,rRST,rRCV_D,sTMG,sPWM(1),rCTRL(1));
	DUT2 : PWM_CURV generic map(2 , FALSE ) port map(rCLK,rRST,rRCV_D,sTMG,sPWM(2),rCTRL(2));
	DUT3 : PWM_CURV generic map(3 , FALSE ) port map(rCLK,rRST,rRCV_D,sTMG,sPWM(3),rCTRL(3));

	-- clk gen
	process
	begin
		rCLK <= '0'; wait for cCLK_PERI / 2;
		rCLK <= '1'; wait for cCLK_PERI / 2;
	end process;

	-- RST gen
	process
	begin
		rRST <= '1'; wait for cCLK_PERI * 100;
		rRST <= '0'; wait ;
	end process;

	-- RCV_D gen
	process
	begin
		rRCV   <= rRCV + '1';
		rRCV_D <= rRCV - x"7F";
		wait for cCLK_PERI * 500;
	end process;

end SIM;
