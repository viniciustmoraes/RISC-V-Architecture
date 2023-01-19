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
		0 => x"0000_1111", -- instruction 0x01
		1 => x"0000_ABCD", -- instruction 0x02
		2 => x"AAAA_0000", -- ...
		3 => x"0000_AE00",
		4 => x"FFFF_FFFF",
		5 => x"1010_0101",
		others => x"0000_0000"
	);

	-- combinational output (async)
	Data_out <= Data_Rom(to_integer(unsigned(Addr_in)));

end ROM_a;
