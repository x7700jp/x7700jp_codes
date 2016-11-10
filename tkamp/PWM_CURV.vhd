----------------------------------------------------------------------------------
-- Company: 
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
-- Lattice ROM IPを使用
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- my package include
use work.PWM_CURV_PKG.ALL;

entity PWM_CURV is
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
end PWM_CURV;

architecture RTL of PWM_CURV is

	-- constant
	constant cCNT_MAX_MASTER : std_logic_vector(7 downto 0) := conv_std_logic_vector(127,8);

	-- signal
	signal rCNT_MASTER : std_logic_vector(7 downto 0):= (others => '0');
	signal rTMG        : std_logic                   := '0';
	signal sPWM_CRV    : std_logic_vector(6 downto 0);
	signal rPWM_CRV_LT : std_logic_vector(6 downto 0):= (others => '1');
	signal rCNT        : std_logic_vector(7 downto 0):= (others => '0');
	signal rBRK_LT     : std_logic_vector(6 downto 0):= (others => '0');
	signal gRCV_D      : std_logic_vector(7 downto 0);
	signal rROM_CTRL   : std_logic                   := '0';

	type tST_CTRL is (ROM_READ1,ROM_READ2,ROM_READ3,IDLE);
	signal rST_CTRL : tST_CTRL := ROM_READ1;

	signal gCTRL      : std_logic_vector(1 downto 0);
	signal rCTRL      : std_logic_vector(1 downto 0):= (others => '0');
	signal rPWM       : std_logic                   := '0';
	
begin
	-- master
	G_MASTER : if (MASTER = TRUE) generate
		P_TMG_GEN : process(iCLK)
		begin
			if (iCLK'event and iCLK = '1') then
				if (iRST = '1') then
					rCNT_MASTER <= (others => '0');
					rTMG        <= '0';
				elsif (rCNT_MASTER = cCNT_MAX_MASTER) then
					rCNT_MASTER <= (others => '0');
					rTMG        <= '1';
				else
					rCNT_MASTER <= rCNT_MASTER + '1';
					rTMG        <= '0';
				end if;
			end if;
		end process;

		bTMG <= rTMG;
	end generate;
	
	-- slave
	G_SLAVE : if (MASTER = FALSE) generate
		bTMG <= 'Z';

		P_TMG_GEN : process(iCLK)
		begin
			if (iCLK'event and iCLK = '1') then
				if (iRST = '1') then
					rTMG <= '0';
				else
					rTMG <= bTMG;
				end if;
			end if;
		end process;
	end generate;

	-- gate
	gRCV_D <= x"80"  when(rROM_CTRL = '1'  ) else
	          x"81"  when(iRCV_D    = x"80") else
	          iRCV_D ;

	gCTRL  <= "00" when(rBRK_LT(6) = '0' and sPWM_CRV = (sPWM_CRV'high downto 0 => '0')) else -- free
	          --"11" when(rBRK_LT(6) = '1' and sPWM_CRV(5 downto 0) < rBRK_LT(5 downto 0)) else -- break
	          "01" when(iRCV_D(7)  = '0') else
	          "10" ; --(iRCV_D(7)  = '1') 

	-- FF
	P_FF : process(iCLK)
	begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rCTRL <= (others => '0');
			else
				rCTRL <= gCTRL;
			end if;
		end if;
	end process;


	-- LT
	P_LT : process(iCLK)
	begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rST_CTRL  <= ROM_READ1;
				rROM_CTRL <= '0';
				rBRK_LT   <= (others => '0');
			else
				case rST_CTRL is
				when ROM_READ1 =>
					rROM_CTRL <= '1';
					rST_CTRL  <= ROM_READ2;

				when ROM_READ2 =>
					rROM_CTRL <= '0';
					rST_CTRL  <= ROM_READ3;
				
				when ROM_READ3 =>
					rBRK_LT   <= sPWM_CRV;
					rST_CTRL  <= IDLE;

				when IDLE     =>
					rST_CTRL  <= IDLE;
				end case;
			end if;
		end if;
	end process;

	-- PWM_CURV_PKG
	G_ROM0 :if(CH = 0) generate
	--	U_CH0 : PWM_CURV_ROM0 port map(Address , OutClock , OutClockEn , Reset , Q        );
		U_CH0 : PWM_CURV_ROM0 port map(gRCV_D  , iCLK     , '1'        , iRST  , sPWM_CRV );
	end generate;

	G_ROM1 :if(CH = 1) generate
		U_CH1 : PWM_CURV_ROM1 port map(gRCV_D  , iCLK     , '1'        , iRST  , sPWM_CRV );
	end generate;

	G_ROM2 :if(CH = 2) generate
		U_CH2 : PWM_CURV_ROM2 port map(gRCV_D  , iCLK     , '1'        , iRST  , sPWM_CRV );
	end generate;

	G_ROM3 :if(CH = 3) generate
		U_CH3 : PWM_CURV_ROM3 port map(gRCV_D  , iCLK     , '1'        , iRST  , sPWM_CRV );
	end generate;

	-- counter
	P_CNT : process(iCLK)
	begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rCNT        <= (others => '0');
				rPWM        <= '0';
				rPWM_CRV_LT <= (others => '1');
			elsif (rTMG = '1') then
				rCNT        <= (others => '0');
				rPWM        <= '1';
				rPWM_CRV_LT <= sPWM_CRV;
			elsif (rCNT = (cCNT_MAX_MASTER-x"05")) then
				rPWM <= '0';
			elsif (rCNT = rPWM_CRV_LT ) then
				rCNT <= rCNT + '1';
				rPWM <= '0';
			else
				rCNT <= rCNT + '1';
			end if;
		end if;
	end process;

	-- output
	oPWM  <= rPWM;
	oCTRL <= rCTRL;

end RTL;
