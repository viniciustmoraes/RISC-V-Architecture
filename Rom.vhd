library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity rom is
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_out:	out std_logic_vector(7 downto 0)
			);
end rom;

architecture rom_a of rom is

type rom is array(0 to 255) of std_logic_vector(7 downto 0);

signal Data_Rom : rom ;



--------------- BEGIN -----------------------------------------------------------------
begin
-- rw='1' alors lecture
	acces_rom:process(rst, clk)
		begin
		
		if rst='1' then

				Data_Rom(0) <= (others=>'0');
				Data_Rom(1) <= (others=>'0');

		else
			if rising_edge(clk) then
				if en='1'then
					Data_out <= Data_Rom(to_integer(unsigned(Adress)));
				end if;

			end if;
		end if;
		
	end process acces_rom;

end rom_a;
