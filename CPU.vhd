-- Copyright (C) 2022  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 22.1std.0 Build 915 10/25/2022 SC Lite Edition"
-- CREATED		"Sat Jan  7 21:44:36 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CPU IS 
	PORT
	(
		MAX10_CLK1_50 :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END CPU;

ARCHITECTURE bdf_type OF CPU IS 

COMPONENT fetch
	PORT(en : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 PC_load : IN STD_LOGIC;
		 PC_Jump : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PC_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT seg7_lut
	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dig2dec
	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rom
	PORT(en : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 Adress : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	0 :  STD_LOGIC;
SIGNAL	1 :  STD_LOGIC;
SIGNAL	HE :  STD_LOGIC;
SIGNAL	HEX_ALTERA_SYNTHESIZED0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 








b2v_Fetch : fetch
PORT MAP(en => 1,
		 clk => MAX10_CLK1_50,
		 PC_out => SYNTHESIZED_WIRE_5);


b2v_inst : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_0,
		 oSEG => HEX_ALTERA_SYNTHESIZED4(6 DOWNTO 0));


b2v_inst1 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_1,
		 oSEG => HEX_ALTERA_SYNTHESIZED3(6 DOWNTO 0));









b2v_inst2 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_2,
		 oSEG => HEX_ALTERA_SYNTHESIZED2(6 DOWNTO 0));


b2v_inst3 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_3,
		 oSEG => HEX_ALTERA_SYNTHESIZED1(6 DOWNTO 0));


b2v_inst4 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_4,
		 oSEG => HEX_ALTERA_SYNTHESIZED0(6 DOWNTO 0));


b2v_inst5 : dig2dec
PORT MAP(		 seg0 => SYNTHESIZED_WIRE_4,
		 seg1 => SYNTHESIZED_WIRE_3,
		 seg2 => SYNTHESIZED_WIRE_2,
		 seg3 => SYNTHESIZED_WIRE_1,
		 seg4 => SYNTHESIZED_WIRE_0);



b2v_Program_Memory : rom
PORT MAP(Adress => SYNTHESIZED_WIRE_5);

HEX0 <= HEX_ALTERA_SYNTHESIZED0;
HEX1 <= HEX_ALTERA_SYNTHESIZED1;
HEX2 <= HEX_ALTERA_SYNTHESIZED2;
HEX3 <= HEX_ALTERA_SYNTHESIZED3;
HEX4 <= HEX_ALTERA_SYNTHESIZED4;
HEX5(7) <= 1;
HEX5(6) <= 1;
HEX5(5) <= 1;
HEX5(4) <= 1;
HEX5(3) <= 1;
HEX5(2) <= 1;
HEX5(1) <= 1;
HEX5(0) <= 1;

0 <= '0';
1 <= '1';
HE <= '1';
HEX_ALTERA_SYNTHESIZED0(7) <= '1';
HEX_ALTERA_SYNTHESIZED1(7) <= '1';
HEX_ALTERA_SYNTHESIZED2(7) <= '1';
HEX_ALTERA_SYNTHESIZED3(7) <= '1';
HEX_ALTERA_SYNTHESIZED4(7) <= '1';
END bdf_type;