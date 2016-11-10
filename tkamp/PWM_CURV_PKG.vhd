----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/04/28 14:32:09
-- Design Name: 
-- Module Name: PWM_CURV_PKG - RTL
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

package PWM_CURV_PKG is

	component PWM_CURV_ROM0
	port (
		Address    : in   std_logic_vector(7 downto 0);
		OutClock   : in   std_logic;
		OutClockEn : in   std_logic;
		Reset      : in   std_logic;
		Q          : out  std_logic_vector(6 downto 0)
	);
	end component;

	component PWM_CURV_ROM1
	port (
		Address    : in   std_logic_vector(7 downto 0);
		OutClock   : in   std_logic;
		OutClockEn : in   std_logic;
		Reset      : in   std_logic;
		Q          : out  std_logic_vector(6 downto 0)
	);
	end component;

	component PWM_CURV_ROM2
	port (
		Address    : in   std_logic_vector(7 downto 0);
		OutClock   : in   std_logic;
		OutClockEn : in   std_logic;
		Reset      : in   std_logic;
		Q          : out  std_logic_vector(6 downto 0)
	);
	end component;

	component PWM_CURV_ROM3
	port (
		Address    : in   std_logic_vector(7 downto 0);
		OutClock   : in   std_logic;
		OutClockEn : in   std_logic;
		Reset      : in   std_logic;
		Q          : out  std_logic_vector(6 downto 0)
	);
	end component;

end PWM_CURV_PKG;
