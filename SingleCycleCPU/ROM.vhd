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
		0 => 32b"000000001000_00000_00010_0000_01", -- instruction 0x00 -- set rp: addi r2, zero, 8
		1 => 32b"000000000001_00000_01010_0000_01", -- instruction 0x01 -- test: addi r10, zero, 1
		2 => 32b"000000000000_00000_01010_0101_01", -- instruction 0x02 -- push r10
		3 => 32b"000000000110_00000_00011_0100_11", -- ... -- call func
		4 => 32b"000000000000_00000_01010_1111_01", -- pop r10
		5 => 32b"000000000001_01010_01011_0000_01", -- addi r11 r10 1
		6 => 32b"000000000011_00000_01010_0000_01", -- func : addi r10 r0 3
		7 => 32b"00000000_00000_00000_0101_11", -- ret
		others => x"0000_0000"
	);

	-- combinational output (async)
	Data_out <= Data_Rom(to_integer(unsigned(Addr_in)));

end ROM_a;
