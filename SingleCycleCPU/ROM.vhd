library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity ROM is
	generic(
			addr_width: integer := 5
			-- ROM address width, in bits
			-- determines the number of rows (2^addr_width)
			);
	port(
			Adress	:	in std_logic_vector(addr_width-1 downto 0); -- We choose 32 possible ROM instructions
			Switches:	in std_logic_vector(3 downto 0); -- We take 4 immediate values from the board switches
			Data_out:	out std_logic_vector(31 downto 0) -- We choose 32 bits for the instructions 
			);
end ROM;

architecture rom_a of ROM is

type rom is array(0 to 2**addr_width-1) of std_logic_vector(31 downto 0);

signal Data_Rom : rom ;
signal current_data : std_logic_vector(31 downto 0);
signal format : std_logic_vector(1 downto 0);
signal operator : std_logic_vector(3 downto 0);

begin
-- instruction memory
-- 32-bit instructions
-- capacity: 256 rows (default)

	-- read-only-memory contents
	Data_Rom <= (
		0 => 32b"000000001000_00000_00010_0000_01", -- instruction 0x00 -- set rp: addi r2 zero 8
		1 => 32b"000000000001_00000_01010_0000_01", -- instruction 0x01 -- test: addi r10 zero 1
		2 => 32b"000000000000_00000_01010_0101_01", -- instruction 0x02 -- push r10
		3 => 32b"000000000110_00000_00011_0100_11", -- ... -- call func
		4 => 32b"000000000000_00000_01010_1111_01", -- pop r10
		5 => 32b"000000000001_01010_01011_0000_01", -- addi r11 r10 1
		6 => 32b"000000000011_00000_01010_0000_01", -- func : addi r10 zero 3
		7 => 32b"00000000_00000_00000_0101_11", -- ret
		others => x"0000_0000"
	);

	-- Definition of the instructions saved on the ROM

	-- Data_Rom(0) <= 32b"00000_00100_0000_01"; 		-- ADDI 0x04 0x00 Imm
	-- Data_Rom(1) <= 32b"00000_00101_0000_01"; 		-- ADDI 0x05 0x00 Imm
	-- Data_Rom(2) <= 32b"00101_00100_00110_0011_00";	-- OR 0x06 0x04 0x05
	-- Data_Rom(3) <= 32b"00110_00111_0101_00"; 		-- NOT 0x07 0x06
	-- Data_Rom(4) <= 32b"00111_01001_1010_00";		-- MOV 0x09 0x07 
	-- Data_Rom(5) <= 32b"00111_1000_00"; 				-- CLR 0x07
	-- Data_Rom(6) <= 32b"00000_01001_1101_01";  		-- LW 0x09 0x00 

	-- Saves NOP to all the other instructions

	-- generate_nop: for i in 7 to (2**addr_width-1) generate
	--	Data_Rom(i) <= 32b"1001_00"; -- NOP
	-- end generate;

-- 	Output ROM logic

	acces_rom:process(all)
		begin
		
		-- Output logic

		current_data <= Data_Rom(to_integer(unsigned(Adress)));
		format <= current_data(1 downto 0);
		operator <= current_data(5 downto 2);

    -- interface with fpga board
		if (format = "01") and (operator /= "1101") and (operator /= "1110") then -- Verifies if the format is 01, which implies the use of immediate values (switches)
			Data_out(15 downto 0) <= current_data(15 downto 0);
			Data_out(19 downto 16) <= Switches;
			Data_out(31 downto 20) <= "000000000000"; 
		
		else
    -- normal behavior (combinational output, async)
			Data_out <= current_data;

		end if;

	end process acces_rom;

end rom_a;
