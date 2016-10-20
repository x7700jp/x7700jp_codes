----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/04/28 16:14:24
-- Design Name: 
-- Module Name: bench_TKRCV - Behavioral
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
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bench_TKRCV is
--  Port ( );
end bench_TKRCV;

architecture Behavioral of bench_TKRCV is
	component TKRCV
	generic (
		CW       : integer := 7   ; -- PERI_GEN cnt Width
		CNT      : integer := 110 ; -- 1.4ms/256/clk_peri
		RCV_ZERO : integer := 319 ; -- CNT * clk_peri * ZERO = 1500 us
		RCV_LOW  : integer := 446 ; -- default ZERO + 127
		RCV_HIGH : integer := 192   -- default ZERO - 127
	);
	port (
		iCLK  : in    std_logic;
		iRST  : in    std_logic;
		iRCV  : in    std_logic;
		oRCV  : out   std_logic_vector(7 downto 0)
	);
	end component;

	constant cCW       : integer := 7   ;
	constant cCNT      : integer := 93  ;
	constant cRCV_ZERO : integer := 318 ;
	constant cRCV_LOW  : integer := 191 ;
	constant cRCV_HIGH : integer := 445 ;

	signal rCLK    : std_logic := '0';
	signal rRST    : std_logic := '1';
	signal rRCV    : std_logic := '0';
	constant cPERI  : time := 1 us / 20 ; -- 20MHz

begin

	U_DUT : TKRCV
	generic map(
		CW       => cCW       ,
		CNT      => cCNT      ,
		RCV_ZERO => cRCV_ZERO ,
		RCV_LOW  => cRCV_LOW  ,
		RCV_HIGH => cRCV_HIGH
	)
	port map(
		iCLK  => rCLK ,
		iRST  => rRST ,
		iRCV  => rRCV ,
		oRCV  => open
		
	);

	-- clk gen
	process begin
		rCLK <= '0'; wait for cPERI/2;
		rCLK <= '1'; wait for cPERI/2;
	end process;

	process begin
		rRST <= '1'; wait for cPERI*100;
		rRST <= '0'; wait ;
	end process;

	process begin
		rRCV <= '0'; wait for 1 ms; rRCV <= '1'; wait for 1500 us;
		rRCV <= '0'; wait for 1 ms; rRCV <= '1'; wait for 1000 us;
		rRCV <= '0'; wait for 1 ms; rRCV <= '1'; wait for  800 us;
		rRCV <= '0'; wait for 1 ms; rRCV <= '1'; wait for 2000 us;
		rRCV <= '0'; wait for 1 ms; rRCV <= '1'; wait for 2200 us;
	end process;

end Behavioral;
