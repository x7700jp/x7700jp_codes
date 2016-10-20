----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/04/28 16:14:24
-- Design Name: 
-- Module Name: bench_TKSERVO - Behavioral
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

entity bench_TKSERVO is
--  Port ( );
end bench_TKSERVO;

architecture Behavioral of bench_TKSERVO is
	component TKSERVO
	generic (
		MASTER : boolean := TRUE; -- TRUE:MASTER / FALSE:SLAVE
		CW     : integer := 7   ; -- PERI_GEN cnt Width
		CNT    : integer := 109
	);
	port (
		iCLK   : in    std_logic;
		iRST   : in    std_logic;
		iANGLE : in    std_logic_vector (7 downto 0);
		bTMG   : inout std_logic; -- MASTER TRUE : output / FALSE : input
		bPERI  : inout std_logic; -- MASTER TRUE : output / FALSE : input
		oSERVO : out   std_logic
	);
	end component;

	constant cCW  : integer := 7   ;
	constant cCNT : integer := 109 ;

	signal rCLK    : std_logic                     := '0';
	signal rRST    : std_logic                     := '1';
	signal rANGLE1 : std_logic_vector (7 downto 0) := (others => '0');
	signal rANGLE2 : std_logic_vector (7 downto 0) := (others => '0');
	signal sTMG    : std_logic;
	signal sPERI   : std_logic;
	signal sSERVO1 : std_logic;
	signal sSERVO2 : std_logic;

	constant cPERI  : time := 1 us / 20 ; -- 20MHz

begin

	U_DUT1 : TKSERVO
	generic map(
		MASTER => TRUE , -- TRUE:MASTER / FALSE:SLAVE
		CW     => cCW  , -- PERI_GEN cnt Width
		CNT    => cCNT
	)
	port map(
		iCLK   => rCLK    ,
		iRST   => rRST    ,
		iANGLE => rANGLE1 ,
		bTMG   => sTMG    ,
		bPERI  => sPERI   ,
		oSERVO => sSERVO1
	);

	U_DUT2 : TKSERVO
	generic map(
		MASTER => FALSE , -- TRUE:MASTER / FALSE:SLAVE
		CW     => cCW  , -- PERI_GEN cnt Width
		CNT    => cCNT
	)
	port map(
		iCLK   => rCLK    ,
		iRST   => rRST    ,
		iANGLE => rANGLE2 ,
		bTMG   => sTMG    ,
		bPERI  => sPERI   ,
		oSERVO => sSERVO2
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
		rANGLE1 <= conv_std_logic_vector(  0,8); rANGLE2 <= conv_std_logic_vector(  0,8); wait for 30 ms;
		rANGLE1 <= conv_std_logic_vector( 50,8); rANGLE2 <= conv_std_logic_vector( 60,8); wait for 30 ms;
		rANGLE1 <= conv_std_logic_vector(127,8); rANGLE2 <= conv_std_logic_vector(127,8); wait for 30 ms;
		rANGLE1 <= conv_std_logic_vector(255,8); rANGLE2 <= conv_std_logic_vector(240,8); wait for 30 ms;
		rANGLE1 <= conv_std_logic_vector(200,8); rANGLE2 <= conv_std_logic_vector(240,8); wait for 30 ms;
		rANGLE1 <= conv_std_logic_vector(128,8); rANGLE2 <= conv_std_logic_vector(240,8); wait for 30 ms;
	end process;

end Behavioral;
