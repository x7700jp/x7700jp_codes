----------------------------------------------------------------------------------
-- Create Date:    2016.07.18
-- Design Name:    TK_AMP_TOP
-- Module Name:    TOP - RTL 
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

entity TOP is
generic (
	USE_CH2 : boolean := TRUE;
	USE_CH3 : boolean := TRUE;
	USE_CH4 : boolean := TRUE
);
port (
	I2C_SCL : inout std_logic; -- 86
	I2C_SDA : inout std_logic; -- 85
	
	SPI_CK  : inout std_logic; -- 31
	SPI_SO  : inout std_logic; -- 32
	SPI_SI  : inout std_logic; -- 49
	SPI_CS  : inout std_logic; -- 27
	
	RX_CH1  : in    std_logic; -- 34
	RX_CH2  : in    std_logic; -- 35
	RX_CH3  : in    std_logic; -- 36
	RX_CH4  : in    std_logic; -- 37
	
	CH1_RH  :   out std_logic; -- 69
	CH1_RL  :   out std_logic; -- 68
	CH1_LH  :   out std_logic; -- 67
	CH1_LL  :   out std_logic; -- 66

	CH2_RH  :   out std_logic; -- 65
	CH2_RL  :   out std_logic; -- 64
	CH2_LH  :   out std_logic; -- 63
	CH2_LL  :   out std_logic; -- 62

	CH3_RH  :   out std_logic; -- 54
	CH3_RL  :   out std_logic; -- 53
	CH3_LH  :   out std_logic; -- 52
	CH3_LL  :   out std_logic; -- 51

	CH4_RH  :   out std_logic; -- 39
	CH4_RL  :   out std_logic; -- 38
	CH4_LH  :   out std_logic; -- 41
	CH4_LL  :   out std_logic  -- 40
);
end TOP;


architecture RTL of TOP is
	
	-- XO2 primitive
	-- On Chip Oscillator
	component OSCH
	generic (NOM_FREQ : String := "10.23");
	port (
		STDBY    : in  std_logic;
		OSC      : out std_logic;
		SEDSTDBY : out std_logic
	);
	end component;

	-- user logic
	component WRAP_RCV_OUT
	generic(
		CH     : integer := 0   ; -- ch 0 to 3
		MASTER : boolean := True  -- master:true / slave:false
	);
	port(
		iCLK     : in    std_logic;
		iRST     : in    std_logic;
		iRCV     : in    std_logic;
		bTMG     : inout std_logic; -- master:out / slave:in
		oOUT_LH  :   out std_logic;
		oOUT_RH  :   out std_logic;
		oxOUT_LL :   out std_logic;
		oxOUT_RL :   out std_logic
	);
	end component;

	-- signal
	signal sCLK     : std_logic;
	signal rRST     : std_logic                    := '1';
	signal sTMG     : std_logic;
	signal sRX_CH   : std_logic_vector(3 downto 0) ;
	type tRX_CH_ARRY is array (0 to 1) of std_logic_vector(3 downto 0);
	constant cRX_CH : tRX_CH_ARRY                  := (others => (others => '0'));
	signal rRX_CH   : tRX_CH_ARRY                  := cRX_CH;
	signal sOUT_RH  : std_logic_vector(3 downto 0) ;
	signal sOUT_LH  : std_logic_vector(3 downto 0) ;
	signal sxOUT_RL : std_logic_vector(3 downto 0) ;
	signal sxOUT_LL : std_logic_vector(3 downto 0) ;


begin
	
	PR3 : OSCH
	-- synthesis translate_off
	generic map (NOM_FREQ => "10.23")
	-- synthesis translate_on
	port map (
		STDBY    => '0'  , -- 0:Enabled, 1:Disabled
		OSC      => sCLK ,
		SEDSTDBY => open
	);

	-- USER_LOGIC
	-- input buffer
	P_FF : process(sCLK)
	begin
		if (sCLK'event and sCLK = '1') then
			rRX_CH <= rRX_CH(0) & sRX_CH;
			rRST   <= '0';
		end if;
	end process;

--	U_RCV_OUT  : WRAP_RCV_OUT generic map(CH , MASTER)port map(iCLK , iRST , iRCV      , bTMG , oOUT_LH    , oOUT_RH    , oxOUT_LL    , oxOUT_RL   );
	U_RCV_OUT0 : WRAP_RCV_OUT generic map(0  , TRUE  )port map(sCLK , rRST , rRX_CH(1)(0) , sTMG , sOUT_LH(0) , sOUT_RH(0) , sxOUT_LL(0) , sxOUT_RL(0));
	
	CH2_ON : if USE_CH2 = TRUE generate
		U_RCV_OUT1 : WRAP_RCV_OUT generic map(1  , FALSE )port map(sCLK , rRST , rRX_CH(1)(1) , sTMG , sOUT_LH(1) , sOUT_RH(1) , sxOUT_LL(1) , sxOUT_RL(1));
	end generate;

	CH2_OFF : if USE_CH2 = FALSE generate
		sOUT_LH(1)  <= '0'; sOUT_RH(1)  <= '0';
		sxOUT_LL(1) <= '1'; sxOUT_RL(1) <= '1';
	end generate;

	CH3_ON : if USE_CH3 = TRUE generate
		U_RCV_OUT2 : WRAP_RCV_OUT generic map(2  , FALSE )port map(sCLK , rRST , rRX_CH(1)(2) , sTMG , sOUT_LH(2) , sOUT_RH(2) , sxOUT_LL(2) , sxOUT_RL(2));
	end generate;

	CH3_OFF : if USE_CH3 = FALSE generate
		sOUT_LH(2)  <= '0'; sOUT_RH(2)  <= '0';
		sxOUT_LL(2) <= '1'; sxOUT_RL(2) <= '1';
	end generate;

	CH4_ON : if USE_CH4 = TRUE generate
		U_RCV_OUT3 : WRAP_RCV_OUT generic map(3  , FALSE )port map(sCLK , rRST , rRX_CH(1)(3) , sTMG , sOUT_LH(3) , sOUT_RH(3) , sxOUT_LL(3) , sxOUT_RL(3));
	end generate;

	CH4_OFF : if USE_CH4 = FALSE generate
		sOUT_LH(3)  <= '0'; sOUT_RH(3)  <= '0';
		sxOUT_LL(3) <= '1'; sxOUT_RL(3) <= '1';
	end generate;
	

	I2C_SCL <= 'Z';
	I2C_SDA <= 'Z';
	SPI_CK  <= 'Z';
	SPI_SO  <= 'Z';
	SPI_SI  <= 'Z';
	SPI_CS  <= 'Z';
	
	sRX_CH <= RX_CH4 &
	          RX_CH3 &
	          RX_CH2 &
	          RX_CH1 ;
	
	CH1_RH <=  sOUT_RH(0) ;
	CH1_RL <= sxOUT_RL(0) ;
	CH1_LH <=  sOUT_LH(0) ;
	CH1_LL <= sxOUT_LL(0) ;

	CH2_RH <=  sOUT_RH(1) ;
	CH2_RL <= sxOUT_RL(1) ;
	CH2_LH <=  sOUT_LH(1) ;
	CH2_LL <= sxOUT_LL(1) ;

	CH3_RH <=  sOUT_RH(2) ;
	CH3_RL <= sxOUT_RL(2) ;
	CH3_LH <=  sOUT_LH(2) ;
	CH3_LL <= sxOUT_LL(2) ;

	CH4_RH <=  sOUT_RH(3) ;
	CH4_RL <= sxOUT_RL(3) ;
	CH4_LH <=  sOUT_LH(3) ;
	CH4_LL <= sxOUT_LL(3) ;


end RTL;
