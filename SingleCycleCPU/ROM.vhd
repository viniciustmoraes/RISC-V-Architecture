library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity ROM is
	generic(
			addr_width: integer := 8
			-- ROM address width, in bits
			-- determines the number of rows (2^addr_width)
			);
	port(
			Addr_in	:	in std_logic_vector(addr_width-1 downto 0);
			Data_out :	out std_logic_vector(31 downto 0)
			);
end ROM;

architecture ROM_a of ROM is

type rom is array(0 to 2**addr_width-1) of std_logic_vector(31 downto 0);

signal Data_Rom : rom ;

begin
-- instruction memory
-- 32-bit instructions
-- capacity: 256 rows (default)

	-- read-only-memory contents
	Data_Rom <= (
		0 => 32b"000000000111_00000_00010_0000_01", -- instruction 0x00 -- test: addi r2, zero, 7
		1 => 32b"000000000101_00000_00001_0000_01", -- instruction 0x01 -- addi r1, zero, 5
		2 => 32b"00001_00010_00011_0001_00", -- instruction 0x02 -- sub r3, r2, r1
		3 => 32b"000000000001_00000_00011_1110_01", -- ... -- sw r3, 1(zero)
		4 => 32b"000000000001_00000_00100_1101_01", -- lw r4, 1(zero)
		5 => 32b"111111111111_00100_00100_0000_01", -- addi r4, r4, -1
		6 => 32b"00000000_00100_00011_0001_11", -- bge r3, r4, test
		others => x"0000_0000"
	);

	-- combinational output (async)
	Data_out <= Data_Rom(to_integer(unsigned(Addr_in)));

end ROM_a;
