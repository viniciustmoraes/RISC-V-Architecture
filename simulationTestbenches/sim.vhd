LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

LIBRARY work;

ENTITY sim IS 
END sim;

ARCHITECTURE bdf_type OF sim IS 

COMPONENT alu
	PORT(clk : IN STD_LOGIC;
		 SelOp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 X : IN signed(31 DOWNTO 0);
		 Y : IN signed(31 DOWNTO 0);
		 OutALU : OUT signed(31 DOWNTO 0);
		 Status : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;

COMPONENT registerfile
	PORT(clk : IN STD_LOGIC;
		 rw : IN STD_LOGIC;
		 en : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 Addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 AddrRA : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 AddrRB : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Data_in : IN signed(31 DOWNTO 0);
		 OutA : OUT signed(31 DOWNTO 0);
		 OutB : OUT signed(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  SIGNED(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  SIGNED(31 DOWNTO 0);

-- inputs
signal clk: std_logic;
signal rw, en, rst: std_logic;
signal Data_in: signed(31 downto 0);
signal Addr, AddrRA, AddrRB: std_logic_vector(4 downto 0);
signal SelOp: std_logic_vector(3 downto 0);
-- outputs
signal OutALU: signed(31 downto 0);
signal Status: std_logic_vector(2 downto 0);

BEGIN 

alu_inst: alu
PORT MAP(X => SYNTHESIZED_WIRE_0,
		 Y => SYNTHESIZED_WIRE_1,
		 clk => clk,
		 SelOp => SelOP,
		 OutALU => OutALU,
		 Status => Status);


regfile_inst: registerfile
PORT MAP(OutA => SYNTHESIZED_WIRE_0,
		 OutB => SYNTHESIZED_WIRE_1,
		 clk => clk,
		 rw => rw,
		 en => en,
		 rst => rst,
		 Data_in => Data_in,
		 AddrRA => AddrRA,
		 AddrRB => AddrRB,
		 Addr => Addr);

-- enable register file read/write
en <= '1';

-- reset and clock
clk <= not clk after 10 ns;
rst <= '1', '0' after 20 ns;

test: process begin
-- wait for reset to be released
wait until (rst = '0');

-- put data in RA and RB
Addr <= b"00001"; -- 5x"1" funcionaria?
Data_in <= x"0000_0001";
rw <= '0'; -- write
wait for 20 ns;

Addr <= b"00010";
Data_in <= x"1234_1234";
rw <= '0';
wait for 20 ns;

-- **here begins the ADD instruction**

-- select ALU operation
SelOP <= b"0000"; -- ADD

-- select RegisterFile output
rw <= '1'; -- read
AddrRA <= b"00001";
AddrRB <= b"00010";
wait for 10 ns; -- 1 clock cycle (for outputs to propagate)

-- calculate using ALU
wait for 10 ns; -- for ALU output to propagate
assert OutALU = x"1234_1235" report "Bad result";

end process test;
	
END bdf_type;