library ieee;

use IEEE.STD_LOGIC_1164.ALL;

entity BusSplitter is
	generic(
			address_width : integer := 8
			-- RAM address width, in bits
			-- determines the number of rows in memory (2^address_width)
			-- example: address_width=8 --> RAM has 256 rows
	);
	port(
			Bus_in	:	in std_logic_vector(31 downto 0); -- OutALU is 32 bits long
			LSBits_out:	out std_logic_vector(address_width-1 downto 0) -- RAM Address input is address_width bits long
			);
end BusSplitter;

architecture synth of BusSplitter is

begin
	
	-- Splits input bus (Bus_in) into its address_width-1 least significant bits
	
	LSBits_out <= Bus_in(address_width-1 downto 0);

end synth;
