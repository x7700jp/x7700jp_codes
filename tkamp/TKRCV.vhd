----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/04/28 14:32:09
-- Design Name: 
-- Module Name: TKRCV - RTL
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

entity TKRCV is
generic (
	CW     : integer := 7   ; -- PERI_GEN cnt Width
	CNT    : integer := 110   -- 1.4ms/256/clk_peri
);
port (
	iCLK  : in    std_logic;
	iRST  : in    std_logic;
	iRCV  : in    std_logic;
	oRCV  : out   std_logic_vector(7 downto 0)
);
end TKRCV;

architecture RTL of TKRCV is

	type tSM is (IDLE,CNT_A);
	signal rSM   : tSM                             := IDLE;
	signal rCNT  : std_logic_vector(CW-1 downto 0) := (others => '0');
	signal rCNT2 : std_logic_vector(   8 downto 0) := (others => '0');
	signal rRCV  : std_logic_vector(   7 downto 0) := (others => '0');
	signal gRCV  : std_logic_vector(   8 downto 0) ;
	signal rIN   : std_logic                       := '0';

	constant cRCV_ZERO : std_logic_vector(8 downto 0) := conv_std_logic_vector(273,9); -- 1500 us
	constant cRCV_LOW  : std_logic_vector(8 downto 0) := conv_std_logic_vector(146,9); --  800 us
	constant cRCV_HIGH : std_logic_vector(8 downto 0) := conv_std_logic_vector(400,9); -- 2200 us
begin
	
	--
	P_FF : process(iCLK) begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rIN <= '0';
			else
				rIN <= iRCV;
			end if;
		end if;
	end process;

	P_CNT : process(iCLK) begin
		if (iCLK'event and iCLK = '1') then
			if (iRST = '1') then
				rSM   <= IDLE;
				rCNT  <= (others => '0');
				rCNT2 <= (others => '0');
				rRCV  <= (others => '0');
			else
				case rSM is
				when IDLE =>
					if (iRCV = '1' and rIN = '0') then -- iRCV rising edge det
						rSM   <= CNT_A;
						rCNT  <= (rCNT'high  downto 1 => '0') & '1';
						rCNT2 <= (rCNT2'high downto 1 => '0') & '1';
					else
						rCNT  <= (others => '0');
						rCNT2 <= (others => '0');
					end if;
				when CNT_A =>
					if (iRCV = '0' or cRCV_HIGH < rCNT ) then
						rSM  <= IDLE;
						rRCV <= gRCV(7 downto 0);
					else
						if (rCNT = conv_std_logic_vector(CNT,CW)) then
							rCNT  <= (others => '0');
							rCNT2 <= rCNT2 + '1';
						else
							rCNT <= rCNT + '1';
						end if;
					end if;
				end case;
			end if;
		end if;
	end process;

	-- gate
	gRCV <= "111111110"       when(rCNT2     < cRCV_LOW ) else
			"001111111"       when(cRCV_HIGH < rCNT2    ) else
			rCNT2 - cRCV_ZERO ;
			

	-- output
	oRCV <= rRCV;

end RTL;
