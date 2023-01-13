library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity ram is
	port(
			rw,en		:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0); -- 8 bits address, meaning 128 rows = 4 kb
			Data_in	:	in signed(31 downto 0); -- Data is defined here as being 32 bits long
			Data_out:	out signed(31 downto 0) -- Data is defined here as being 32 bits long
			);
end ram;

architecture ram_a of ram is

type ram is array(0 to 256) of signed(31 downto 0);

signal Data_Ram : ram ;

--------------- BEGIN -----------------------------------------------------------------
begin
-- rw='1' alors lecture
	acces_ram:process(rst, clk)
		begin
		
		if rst='1' then
		
			for k in 0 to 256 loop
				Data_Ram(k) <= (others=>'0');
			end loop;
		
		else
			if rising_edge(clk) then
				if en='1' then
					if(rw='1') then 
						Data_out <= Data_Ram(to_integer(unsigned(Adress)));
					else
						Data_Ram(to_integer(unsigned(Adress))) <= Data_in;
					end if;
				end if;
			end if;
		end if;
		
	end process acces_ram;

end ram_a;
