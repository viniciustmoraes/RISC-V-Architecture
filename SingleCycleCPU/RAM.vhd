library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity RAM is
	generic(
			address_width : integer := 8
			-- RAM address width, in bits
			-- determines the number of rows in memory (2^address_width)
			-- example: address_width=8 --> RAM has 256 rows
	);
	port(
			clk		:	in std_logic;
			we 		:	in std_logic; -- Write Enable (we)
			rst		:	in std_logic; -- Reset (rst)
			Adress	:	in std_logic_vector(address_width-1 downto 0); -- 8 bits address, meaning 256 rows * 32 bits = 8 KB
			AdressB :   in std_logic_vector(address_width-1 downto 0);
			Data_in	:	in std_logic_vector(31 downto 0); -- Data is defined here as being 32 bits long
			Data_out:	out std_logic_vector(31 downto 0); -- Data is defined here as being 32 bits long
			Data_outB : out std_logic_vector(31 downto 0)   -- Output port for 7 segment display reading	
			);
end RAM;

architecture RAM_a of RAM is

type ram is array(0 to 2**address_width-1) of std_logic_vector(31 downto 0);

signal Data_Ram : ram ;

-- 32-bit word RAM
-- 256 rows (default)

-- one address pin (for both read/write)
-- async read, sync write

begin
	-- read from RAM (async)
	Data_out <= Data_Ram(to_integer(unsigned(Adress)));
	Data_outB <= Data_Ram(to_integer(unsigned(AdressB)));

	-- write to RAM (sync)
	write_to_RAM:process(rst, clk) begin
		if rst='1' then
			for k in 0 to 2**address_width-1 loop
				Data_Ram(k) <= (others=>'0');
			end loop;
		else
			if rising_edge(clk) then
				if(we='1') then 
					Data_Ram(to_integer(unsigned(Adress))) <= Data_in;
				end if;
			end if;
		end if;
	end process write_to_RAM;

end RAM_a;
