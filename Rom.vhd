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

--------------- BEGIN -----------------------------------------------------------------
begin





-- Saves NOP to all the other instructions
	for k in (5) to 31 loop
		Data_Rom(k) <= (others=>'00100100000000000000000000000000'); -- Encode the Do Nothing instruction PRESTAR ATENCAO NA ORDEM INVERTIDA DOS BITS
	end loop;

	acces_rom:process(clk)
		begin
		
			if rising_edge(clk) then
				if en='1'then
					if Data_Rom(to_integer(unsigned(Adress)))(1 downto 0) = "10" then -- Verifies if the format is 01 (we need to invert)
						Data_out <= Data_Rom(to_integer(unsigned(Adress)))()
					
					Data_out <= Data_Rom(to_integer(unsigned(Adress)));
				end if;

			end if;
		
	end process acces_rom;

end rom_a;
