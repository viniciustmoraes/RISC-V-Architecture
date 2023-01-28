library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity Fetch is
	generic(
			ROM_addr_width: integer := 5
			-- ROM address width, in bits
			-- determines the number of rows in the ROM (2^addr_width)
			-- example: width=8 --> 256 rows
			);
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			PC_Load	:	in std_logic;	-- "Enable" for jump functions. Must come from the decoder
			PC_Jump	:	in std_logic_vector(ROM_addr_width-1 downto 0);	-- Jump address. Comes from the decoder
			PC_Out	:	out std_logic_vector(ROM_addr_width-1 downto 0)	-- Final program counter, output from fetch block
			);
end Fetch;

architecture Fetch_a of Fetch is

signal PC_counter: std_logic_vector(ROM_addr_width-1 downto 0);

begin

	process (clk, rst) begin
		if rst='1' then
			PC_counter <= (others=>'0');
		else
			if rising_edge(clk) then
				if en='1' then
					if PC_Load='1' then
					-- branch to jump address
						PC_counter <= PC_Jump;
					else
					-- prepare next instruction
						PC_counter <= std_logic_vector(unsigned(PC_counter)+1);
					end if;
				end if;
			end if;
		end if;
	end process;

	PC_out <= PC_counter;

end architecture Fetch_a;

	
			
	