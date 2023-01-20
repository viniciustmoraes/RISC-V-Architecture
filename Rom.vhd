library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity rom is
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			Adress	:	in std_logic_vector(4 downto 0); -- We choose 32 possible ROM instructions
			Switches:	in std_logic_vector(8 downto 0); -- We take 9 immediate values from the board switches
			Data_out:	out std_logic_vector(31 downto 0) -- We choose 32 bits for the instructions 
			);
end rom;

architecture rom_a of rom is

type rom is array(0 to 31) of std_logic_vector(31 downto 0);

signal Data_Rom : rom ;
signal current_data : std_logic_vector(31 downto 0);
signal format : std_logic_vector(1 downto 0);
--------------- BEGIN -----------------------------------------------------------------
begin

	-- Definition of the instructions saved on the ROM

	-- Saves two immdiate values on the registers 0 (00000) and 1 (00001) from the register file
	Data_Rom(0) <= "00000000000000001111100000000001";
	Data_Rom(1) <= "00000000000000001111100001000001";

	-- Operation or between the two saved values, and saves it two register number 5 (00101)
	Data_Rom(2) <= "00000000000000000000100101001100";

	-- Performs a NOT operation on the result of the previous operations, and saves it on register number 6 (00110)
	Data_Rom(3) <= "00000000000000000010100110010100";

	-- Moves the result from register 6 (00110) to register 7 (00111) and then clears register 6 (00110)
	Data_Rom(4) <= "00000000000000000011000111101001";
	
	-- Clears the values stored on register 6
	Data_Rom(5) <= "00000000000000000000000110100000";

	-- Sends the values stored on register 7 to RAM, using the address 00000000
	Data_Rom(6) <= "00000000000000011100000000011011";

	-- Saves NOP to all the other instructions

	generate_nop: for i in 7 to 31 generate
		Data_Rom(i) <= "00000000000000000000000000100100";
	end generate;

-- 	Output ROM logic. 

	acces_rom:process(clk)
		begin
		
		-- Output logic
		if rising_edge(clk) then
			if en='1'then
				current_data <= Data_Rom(to_integer(unsigned(Adress)));
				format <= current_data(1 downto 0);

				if format = "01" then -- Verifies if the format is 01, which implies the use of immediate values (switches)
					Data_out(15 downto 0) <= current_data(15 downto 0);
					Data_out(24 downto 16) <= Switches;
					Data_out(31 downto 25) <= "0000000"; -- We only have 9 switches, which implies that the immediate values can only have 9 bits
				else 
					Data_out <= current_data;

				end if;
			end if;

		end if;
		
	end process acces_rom;

end rom_a;



