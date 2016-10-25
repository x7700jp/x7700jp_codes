----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/05/27 10:46:11
-- Design Name: 
-- Module Name: TE0726_TOP - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - 入力ポート　非同期対策
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TE0726_TOP is
port (
	-- bank34
	iBUTTON    : in    std_logic;
	iRCIN      : in    std_logic_vector( 1 downto 0);
	GPIO       : inout std_logic_vector(25 downto 3);
	PUDC       : inout std_logic;
	CSI_C_P    : out   std_logic;
	CSI_C_N    : out   std_logic;
	CSI_D_P    : out   std_logic_vector( 1 downto 0);
	CSI_D_N    : out   std_logic_vector( 1 downto 0);
	CSI_D0_R_P : out   std_logic;
	CSI_D0_R_N : out   std_logic;
	PWM_L      : inout std_logic;
	PWM_R      : inout std_logic;
	CEC_B      : inout std_logic;
	HDMI_TXC_P : out   std_logic;
	HDMI_TXC_N : out   std_logic;
	HDMI_TX_P  : out   std_logic_vector( 2 downto 0);
	HDMI_TX_N  : out   std_logic_vector( 2 downto 0);
	--bank35
	DSI_C_R_P  : out   std_logic;
	DSI_C_R_N  : out   std_logic;
	DSI_D_R_P  : out   std_logic_vector( 1 downto 0);
	DSI_D_R_N  : out   std_logic_vector( 1 downto 0);
	DSI_XA     : out   std_logic;
	DSI_XB     : out   std_logic;
	--PS
	MIO        : inout std_logic_vector(53 downto  0);
	PS_CLK     : inout std_logic;
	PS_SRSTB   : inout std_logic;
	PS_PORB    : inout std_logic;

	-- PS_DDR
	DDR_VRP      : inout std_logic;
	DDR_VRN      : inout std_logic;
	DDR_WEB      : inout std_logic;
	DDR_RAS_n    : inout std_logic;
	DDR_ODT      : inout std_logic;
	DDR_DRSTB    : inout std_logic;
	DDR_DQS      : inout std_logic_vector( 1 downto 0);
	DDR_DQS_n    : inout std_logic_vector( 1 downto 0);
	DDR_DQ       : inout std_logic_vector(15 downto 0);
	DDR_DM       : inout std_logic_vector( 1 downto 0);
	DDR_CS_n     : inout std_logic;
	DDR_CKE      : inout std_logic;
	DDR_Clk      : inout std_logic;
	DDR_Clk_n    : inout std_logic;
	DDR_CAS_n    : inout std_logic;
	DDR_BankAddr : inout std_logic_vector(2 downto 0);
	DDR_Addr     : inout std_logic_vector(14 downto 0)
);
end TE0726_TOP;

architecture RTL of TE0726_TOP is
	component zsys_wrapper
	port (
		DDR_addr          : inout std_logic_vector ( 14 downto 0 );
		DDR_ba            : inout std_logic_vector ( 2 downto 0 );
		DDR_cas_n         : inout std_logic;
		DDR_ck_n          : inout std_logic;
		DDR_ck_p          : inout std_logic;
		DDR_cke           : inout std_logic;
		DDR_cs_n          : inout std_logic;
		DDR_dm            : inout std_logic_vector ( 1 downto 0 );
		DDR_dq            : inout std_logic_vector ( 15 downto 0 );
		DDR_dqs_n         : inout std_logic_vector ( 1 downto 0 );
		DDR_dqs_p         : inout std_logic_vector ( 1 downto 0 );
		DDR_odt           : inout std_logic;
		DDR_ras_n         : inout std_logic;
		DDR_reset_n       : inout std_logic;
		DDR_we_n          : inout std_logic;
		FIXED_IO_ddr_vrn  : inout std_logic;
		FIXED_IO_ddr_vrp  : inout std_logic;
		FIXED_IO_mio      : inout std_logic_vector ( 31 downto 0 );
		FIXED_IO_ps_clk   : inout std_logic;
		FIXED_IO_ps_porb  : inout std_logic;
		FIXED_IO_ps_srstb : inout std_logic;
		oAXI_GPIO0_TRI_O  : out   std_logic_vector ( 11 downto 0 );
		iAXI_GPIO1_TRI_I  : in    std_logic_vector ( 3 downto 0 );
		iAXI_GPIO2_TRI_I  : in    std_logic_vector ( 31 downto 0 );
		oCLK              : out   std_logic;
		oxRST             : out   std_logic_vector (  0     to 0 )
	);
	end component;
	
	-- vivado ip
	component CLK_CHG
	port (
		rst    : in  std_logic;
		wr_clk : in  std_logic;
		rd_clk : in  std_logic;
		din    : in  std_logic_vector(11 downto 0);
		wr_en  : in  std_logic;
		rd_en  : in  std_logic;
		dout   : out std_logic_vector(11 downto 0);
		full   : out std_logic;
		empty  : out std_logic
	);
	end component;

	component CLK_CHG_PL2PS
	port (
		wr_clk : in  std_logic;
		rd_clk : in  std_logic;
		din    : in  std_logic_vector(31 downto 0);
		wr_en  : in  std_logic;
		rd_en  : in  std_logic;
		dout   : out std_logic_vector(31 downto 0);
		full   : out std_logic;
		empty  : out std_logic
	);
	end component;

	component CLK_GEN20M
	port (
		clk_in1  : in  std_logic; -- Clock in ports
		clk_out1 : out std_logic; -- Clock out ports
		reset    : in  std_logic; -- Status and control signals
		locked   : out std_logic
	);
	end component;

	-- user ip
	component TKSERVO
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
	end component;

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

	signal sFIXED_IO : std_logic_vector(31 downto 0);
	signal sLED      : std_logic_vector( 7 downto 0);
	signal sGPIO     : std_logic_vector(11 downto 0);
	signal rGPIO     : std_logic_vector(11 downto 0) := (others => '0');
	signal sGPIO20M  : std_logic_vector(11 downto 0);

	signal sCLK_PS   : std_logic;
	signal sxRST_PS  : std_logic;
	signal gRST      : std_logic;
	signal sCLK20M   : std_logic;
	signal sLOCKED   : std_logic;

	type tARRY is array (0 to 15) of std_logic_vector(7 downto 0);
	constant cANGLE   : tARRY := (others =>(others => '0'));
	signal   rANGLE   : tARRY := cANGLE;
	signal   sTMG     : std_logic;
	signal   sPERI    : std_logic;
	signal   sSERVO   : std_logic_vector(15 downto 0);
	signal   rSERVO   : std_logic_vector(15 downto 0) := (others => '0');
	signal   rCNT20M  : std_logic_vector(24 downto 0) := (others => '0');
	constant cCNT20M  : std_logic_vector(24 downto 0) := "0100110001001011010000000";
	signal   rTG      : std_logic                     := '0';
	signal   rTG2     : std_logic                     := '0';
	signal   rTMG_CNT : std_logic_vector(3 downto 0) := (others => '0');

	--
	signal   sGPI     : std_logic_vector(3 downto 0) ;
	type tRCIN_ARRY is array (0 to 1) of std_logic_vector(3 downto 0);
	signal   rRCIN    : tRCIN_ARRY                    := (others => (others => '0'));
	signal   rBUTTON  : std_logic_vector( 1 downto 0) := (others => '0');
	signal   sRCV4    : std_logic_vector(31 downto 0);
	signal   sRCV4_PL : std_logic_vector(31 downto 0);

	constant cCW       : integer := 6  ;
	constant cCNT      : integer := 54 ;
	constant cRCV_CW   : integer := 6  ;
	constant cRCV_CNT  : integer := 47  ;
	constant cRCV_ZERO : integer := 318 ;
	constant cRCV_LOW  : integer := 191 ;
	constant cRCV_HIGH : integer := 445 ;

begin

	-- DUT
	U_DUT : zsys_wrapper
	port map(
		DDR_addr          => DDR_Addr      ,
		DDR_ba            => DDR_BankAddr  ,
		DDR_cas_n         => DDR_CAS_n     ,
		DDR_ck_n          => DDR_Clk_n     ,
		DDR_ck_p          => DDR_Clk       ,
		DDR_cke           => DDR_CKE       ,
		DDR_cs_n          => DDR_CS_n      ,
		DDR_dm            => DDR_DM        ,
		DDR_dq            => DDR_DQ        ,
		DDR_dqs_n         => DDR_DQS_n     ,
		DDR_dqs_p         => DDR_DQS       ,
		DDR_odt           => DDR_ODT       ,
		DDR_ras_n         => DDR_RAS_n     ,
		DDR_reset_n       => DDR_DRSTB     ,
		DDR_we_n          => DDR_WEB       ,
		FIXED_IO_ddr_vrn  => DDR_VRN       ,
		FIXED_IO_ddr_vrp  => DDR_VRP       ,
	--	FIXED_IO_mio      => MIO           ,

		FIXED_IO_mio(15 downto  0) => MIO(15 downto  0) ,
		FIXED_IO_mio(27 downto 16) => MIO(39 downto 28) ,
		FIXED_IO_mio(29 downto 28) => MIO(49 downto 48) ,
		FIXED_IO_mio(31 downto 30) => MIO(53 downto 52) ,
		FIXED_IO_ps_clk   => PS_CLK      ,
		FIXED_IO_ps_porb  => PS_PORB     ,
		FIXED_IO_ps_srstb => PS_SRSTB    ,
		oAXI_GPIO0_TRI_O  => sGPIO       , -- std_logic_vector ( 11 downto 0 );
		iAXI_GPIO1_TRI_I  => sGPI        ,
		iAXI_GPIO2_TRI_I  => sRCV4       ,
		oCLK              => sCLK_PS     , -- std_logic;
		oxRST(0)          => sxRST_PS      -- std_logic_vector ( 0      to 0 )
	);

	-- PL
	-- gate
	gRST   <= not sxRST_PS;
	
	-- LT
	P_LT : process(sCLK20M) begin
		if (sCLK20M'event and sCLK20M = '1') then
			if (gRST = '1') then
				rANGLE  <= cANGLE;
				rSERVO  <= (others => '0');
				rCNT20M <= (others => '0');
				rTG     <= '0';
				rTG2    <= '0';
				rTMG_CNT <= (others => '0');
			else
				case sGPIO20M(11 downto 8) is
					when x"0"   => rANGLE( 0) <= sGPIO20M(7 downto 0);
					when x"1"   => rANGLE( 1) <= sGPIO20M(7 downto 0);
					when x"2"   => rANGLE( 2) <= sGPIO20M(7 downto 0);
					when x"3"   => rANGLE( 3) <= sGPIO20M(7 downto 0);
					when x"4"   => rANGLE( 4) <= sGPIO20M(7 downto 0);
					when x"5"   => rANGLE( 5) <= sGPIO20M(7 downto 0);
					when x"6"   => rANGLE( 6) <= sGPIO20M(7 downto 0);
					when x"7"   => rANGLE( 7) <= sGPIO20M(7 downto 0);
					when x"8"   => rANGLE( 8) <= sGPIO20M(7 downto 0);
					when x"9"   => rANGLE( 9) <= sGPIO20M(7 downto 0);
					when x"A"   => rANGLE(10) <= sGPIO20M(7 downto 0);
					when x"B"   => rANGLE(11) <= sGPIO20M(7 downto 0);
					when x"C"   => rANGLE(12) <= sGPIO20M(7 downto 0);
					when x"D"   => rANGLE(13) <= sGPIO20M(7 downto 0);
					when x"E"   => rANGLE(14) <= sGPIO20M(7 downto 0);
					when x"F"   => rANGLE(15) <= sGPIO20M(7 downto 0);
					when others =>
				end case;

				rSERVO  <= sSERVO;
				
				if rCNT20M = cCNT20M then
					rCNT20M <= (others => '0');
					rTG     <= not rTG;
				else
					rCNT20M <= rCNT20M + '1';
				end if;

				if sTMG = '1' then
					if rTMG_CNT = x"9" then
						rTMG_CNT <= (others => '0');
						rTG2 <= not rTG2;
					else
						rTMG_CNT <= rTMG_CNT + '1';
					end if;
				end if;
				
			end if;
		end if;
	end process;

	P_FF_PS : process(sCLK_PS) begin
		if (sCLK_PS'event and sCLK_PS = '1') then
			if (gRST = '1') then
				rBUTTON <= '0';
				rGPIO   <= (others => '0');
				rRCIN   <= (others => '0');
			else
				rBUTTON <= rBUTTON(0) & iBUTTON; -- 非同期対策
				rRCIN   <= rRCIN(0)   & iRCIN;   -- 非同期対策
				rGPIO   <= sGPIO;
			end if;
		end if;
	end process;

	-- クロック乗り換え
	U_IP1 : CLK_CHG
	port map(
		rst    => gRST     ,
		wr_clk => sCLK_PS  ,
		rd_clk => sCLK20M  ,
		din    => sGPIO    ,
		wr_en  => '1'      ,
		rd_en  => '1'      ,
		dout   => sGPIO20M ,
		full   => open     ,
		empty  => open
	);

	-- クロック生成
	U_IP2 :  CLK_GEN20M
	port map(
		clk_in1  => sCLK_PS , -- Clock in ports
		clk_out1 => sCLK20M , -- Clock out ports
		reset    => gRST    , -- Status and control signals
		locked   => sLOCKED
	);

	-- クロック乗り換え
	U_IP3 : CLK_CHG_PL2PS
	port map(
		wr_clk => sCLK20M  ,
		rd_clk => sCLK_PS  ,
		din    => sRCV4_PL ,
		wr_en  => '1'      ,
		rd_en  => '1'      ,
		dout   => sRCV4    ,
		full   => open     ,
		empty  => open
	 );

	-- RCサーボコントローラ マスタ
	U_DUT0 : TKSERVO
	generic map(
		MASTER => TRUE , -- TRUE:MASTER / FALSE:SLAVE
		CW     => cCW  , -- PERI_GEN cnt Width
		CNT    => cCNT
	)
	port map(
		iCLK   => sCLK20M   ,
		iRST   => gRST      ,
		iANGLE => rANGLE(0) ,
		bTMG   => sTMG      ,
		bPERI  => sPERI     ,
		oSERVO => sSERVO(0)
	);

	-- RCサーボコントローラ スレーブ
	G_SLV : for i in 1 to 15 generate
		U_DUT : TKSERVO
		generic map(
			MASTER => FALSE , -- TRUE:MASTER / FALSE:SLAVE
			CW     => cCW   , -- PERI_GEN cnt Width
			CNT    => cCNT
		)
		port map(
			iCLK   => sCLK20M   ,
			iRST   => gRST      ,
			iANGLE => rANGLE(i) ,
			bTMG   => sTMG      ,
			bPERI  => sPERI     ,
			oSERVO => sSERVO(i)
		);
	end generate;

	-- RC受信器 受信→パラレル変換
	U_RCV0 : TKRCV
	generic map(
		CW       => cRCV_CW   ,
		CNT      => cRCV_CNT  ,
		RCV_ZERO => cRCV_ZERO ,
		RCV_LOW  => cRCV_LOW  ,
		RCV_HIGH => cRCV_HIGH
	)
	port map(
		iCLK  => sCLK20M ,
		iRST  => gRST    ,
		iRCV  => rRCIN(0) ,
		oRCV  => sRCV4_PL(7 downto 0)
	);

	U_RCV1 : TKRCV
	generic map(
		CW       => cRCV_CW   ,
		CNT      => cRCV_CNT  ,
		RCV_ZERO => cRCV_ZERO ,
		RCV_LOW  => cRCV_LOW  ,
		RCV_HIGH => cRCV_HIGH
	)
	port map(
		iCLK  => sCLK20M ,
		iRST  => gRST    ,
		iRCV  => rRCIN(1) ,
		oRCV  => sRCV4_PL(15 downto 8)
	);

	sRCV4_PL(31 downto 16) <= (others => '0');

	-- I/O
	-- bank34
	sLED(0) <= sGPIO20M( 4);
	sLED(1) <= sGPIO20M( 5);
	sLED(2) <= sGPIO20M( 6);
	sLED(3) <= sGPIO20M( 7);
	sLED(4) <= sGPIO20M( 8);
	sLED(5) <= sGPIO20M( 9);
	sLED(6) <= sGPIO20M(10);
	sLED(7) <= sGPI(0);

--	GPIO( 2) <= sLED(0);
	GPIO( 3) <= sLED(1);
	GPIO( 4) <= sLED(2);
	GPIO( 5) <= rSERVO( 6); --
	GPIO( 6) <= rSERVO( 7); --
	GPIO( 7) <= rSERVO( 5); --
	GPIO( 8) <= rSERVO( 4); --
	GPIO( 9) <= rSERVO( 1); --
	GPIO(10) <= rSERVO( 0); --
	GPIO(11) <= rSERVO( 3); sGPI(1) <= '0';--
	GPIO(12) <= rSERVO( 8); --
	GPIO(13) <= rSERVO( 9); --
	GPIO(14) <= sLED(3);
	GPIO(15) <= sLED(4);
	GPIO(16) <= rSERVO(11); sGPI(2) <= '0';--
	GPIO(17) <= sLED(5);
	GPIO(18) <= rSERVO(14);
	GPIO(19) <= rSERVO(10); --
	GPIO(20) <= rSERVO(13); --
	GPIO(21) <= rSERVO(15); --
	GPIO(22) <= sLED(7);
	GPIO(23) <= rSERVO( 2); --
	GPIO(24) <= rSERVO(12); --
	GPIO(25) <= sLED(6);

	sGPI(0) <= rBUTTON;

	PUDC       <= 'Z';
	
	PR_CSI_C   : OBUFTDS port map(O => CSI_C_P    , OB => CSI_C_N    , I => '0' , T => '1');
	PR_CSI_D0  : OBUFTDS port map(O => CSI_D_P(0) , OB => CSI_D_N(0) , I => '0' , T => '1');
	PR_CSI_D1  : OBUFTDS port map(O => CSI_D_P(1) , OB => CSI_D_N(1) , I => '0' , T => '1');
	CSI_D0_R_P <= 'Z'; CSI_D0_R_N <= 'Z';
	PWM_L      <= 'Z';
	PWM_R      <= 'Z';
	CEC_B      <= 'Z';

	PR_HDMI_TX1 : OBUFTDS port map(O => HDMI_TX_P(1) , OB => HDMI_TX_N(1) , I => '0' , T => '1');
	PR_HDMI_TX2 : OBUFTDS port map(O => HDMI_TX_P(2) , OB => HDMI_TX_N(2) , I => '0' , T => '1');
	HDMI_TXC_P   <= 'Z'; HDMI_TXC_N   <= 'Z';
	HDMI_TX_P(0) <= 'Z'; HDMI_TX_N(0) <= 'Z';

	--bank35
	DSI_C_R_P    <= 'Z'; DSI_C_R_N    <= 'Z';
	DSI_D_R_P(0) <= 'Z'; DSI_D_R_N(0) <= 'Z';
	DSI_D_R_P(1) <= 'Z'; DSI_D_R_N(1) <= 'Z';

	DSI_XA     <= 'Z';
	DSI_XB     <= 'Z';

end RTL;
