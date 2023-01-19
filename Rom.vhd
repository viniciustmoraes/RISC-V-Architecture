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




	-- Saves NOP to all the other instructions. Must define the proper starting number

-- 	Output ROM logic. 

	acces_rom:process(clk)
		begin
		
		for k in 5 to 31 loop
			Data_Rom(k) <= "00100100000000000000000000000000"; -- Encode the Do Nothing instruction. Must update the instruction for do nothing, considering the new ISA ordering
		
		end loop;
		
		if rising_edge(clk) then
			if en='1'then
				current_data <= Data_Rom(to_integer(unsigned(Adress)));
				format <= current_data(1 downto 0);

				if format = "01" then -- Verifies if the format is 01, which implies the use of immediate values (switches)
					Data_out(15 downto 0) <= current_data(15 downto 0);
					Data_out(24 downto 16) <= Switches(8 downto 0);
					Data_out(31 downto 25) <= "0000000"; -- We only have 9 switches, which implies that the immediate values can only have 9 bits
				else 
					Data_out <= current_data;

				end if;
			end if;

		end if;
		
	end process acces_rom;

end rom_a;



