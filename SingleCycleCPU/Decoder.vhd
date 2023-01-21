library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
	generic(
		ROM_addr_width: integer := 8
		-- ROM address width, in bits
		-- determines the number of rows in the ROM (2^addr_width)
		-- example: width=8 --> 256 rows
	);
	port(
		-- inputs
		Status: in std_logic_vector(2 downto 0); -- ALU status (3 bits: (2) CarryOut, (1) isZero, (0) isPositive)
		PC_now: in std_logic_vector(ROM_addr_width-1 downto 0);
		Instr: in std_logic_vector(31 downto 0); -- instruction from ROM
		SelOp: out std_logic_vector(3 downto 0); -- ALU select operation
		-- outputs
		AddrRA, AddrRB, AddrRdest: out std_logic_vector(4 downto 0);
		Imm32: out std_logic_vector(31 downto 0);
		selImm: out std_logic;
		selRAM: out std_logic;
		we_RegFile: out std_logic;
		we_RAM: out std_logic;
		PC_Load: out std_logic
	);
end entity Decoder;

architecture Decoder_a of Decoder is

-- Common:
signal OpCode: std_logic_vector(5 downto 0);
signal Format: std_logic_vector(1 downto 0);
signal Operator: std_logic_vector(3 downto 0);
signal Imm12: std_logic_vector(11 downto 0);

begin
	-- decoder generates control signals
	-- after only a propagation delay, w/o clock
	-- (asynchronous control unit)

	OpCode <= Instr(5 downto 0);
	Format <= OpCode(1 downto 0);
	Operator <= OpCode(5 downto 2);
	
	decode: process(all) begin
		case(Format) is
			when "00" => -- Rdest, RA[, RB]
				PC_Load <= '0';
				selImm <= '0';
				if (Operator = "0000") or -- ADD
					(Operator = "0001") or -- SUB
					(Operator = "0010") or -- AND
					(Operator = "0011") or -- OR
					(Operator = "0100") or -- XOR
					(Operator = "0101") or -- NOT
					(Operator = "0111") or -- MUL
					(Operator = "1000") or -- CLR
					(Operator = "1010") then -- MOV
					
					SelOp <= Operator;
					AddrRdest <= Instr(10 downto 6);
					AddrRA <= Instr(15 downto 11);
					AddrRB <= Instr(20 downto 16);
					selRAM <= '0';
					we_RegFile <= '1';
					we_RAM <= '0';
					
				elsif (Operator = "1000") then -- NOP
					we_RegFile <= '0';
					we_RAM <= '0';
				end if;
			when "01" => -- Rdest, RA, Imm
				PC_Load <= '0';
				selImm <= '1';
				if (Operator = "0000") or -- ADDI
					(Operator = "0001") or -- SUBI
					(Operator = "0010") or -- ANDI
					(Operator = "0011") or -- ORI
					(Operator = "0100") or -- XORI
					(Operator = "1011") or -- SLLI
					(Operator = "1100") then -- SRLI
					
					SelOp <= Operator;
					AddrRdest <= Instr(10 downto 6);
					AddrRA <= Instr(15 downto 11);
					Imm12 <= Instr(27 downto 16);
					selRAM <= '0';
					we_RegFile <= '1';
					we_RAM <= '0';
				elsif (Operator = "1101") then -- LW
					AddrRdest <= Instr(10 downto 6);
					AddrRA <= Instr(15 downto 11); -- RAM address
					Imm12 <= Instr(27 downto 16); -- offset
					SelOp <= "0000"; -- add RAM address and offset
					selRAM <= '1';
					we_RegFile <= '1';
					we_RAM <= '0';
				elsif (Operator = "1110") then -- SW
					AddrRB <= Instr(10 downto 6); -- value to be stored
					AddrRA <= Instr(15 downto 11); -- RAM address
					Imm12 <= Instr(27 downto 16); -- offset
					SelOp <= "0000"; -- add RAM address and offset
					we_RegFile <= '0';
					we_RAM <= '1';
				end if;
						
			when "11" => -- [RA, RB,] fonction 
					SelOp <= "0001"; -- subtract RA - RB
					we_RegFile <= '0';
					we_RAM <= '0';
					selImm <= '0';
					AddrRA <= Instr(10 downto 6);
					AddrRB <= Instr(15 downto 11);
					Imm12 <= Instr(27 downto 16); -- ROM address of the branching function
					
					if (Operator = "0000") then
					-- BEQ (branch if equal)
					-- combinational statement to define PC_Load before next clock rising edge
						if Status(1) = '1' then -- isZero
							PC_Load <= '1';
						else
							PC_Load <= '0';
						end if;
					elsif (Operator = "0001") then
					-- BGE (branch if greater or equal)
						if (Status(0) = '1') or (Status(1) = '1') then -- isPositive or isZero
							PC_Load <= '1';
						else
							PC_Load <= '0';
						end if;
					elsif (Operator = "0010") then
					-- BNE (branch if not equal)
						if (Status(1) = '0') then -- NOT isZero
							PC_Load <= '1';
						else
							PC_Load <= '0';
						end if;
					elsif (Operator = "0110") then
					-- BLT (branch if less than)
						if (Status(0) = '0') and (Status(1) = '0') then -- (NOT isPositive) and (NOT isZero)
							PC_Load <= '1';
						else
							PC_Load <= '0';
						end if;
					end if;
					
			when others =>
				SelOp <= Operator;
				AddrRdest <= Instr(10 downto 6);
				AddrRA <= Instr(15 downto 11);
				AddrRB <= Instr(20 downto 16);
				selImm <= '0';
				we_RegFile <= '0';
				we_RAM <= '0';
		end case;
	end process decode;
	
	-- sign-extend immediate to 32 bits
	Imm32 <= std_logic_vector(resize(signed(Imm12), 32));
	
end architecture Decoder_a;
	