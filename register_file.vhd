library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity RegisterFile is
	port(
			clk		:	in std_logic;
			Addr 	:	in std_logic_vector(4 downto 0); -- 32 Registers, therefore 5 bit addresses
			rw,en,rst	:	in std_logic;
			Data_in	:	in signed(31 downto 0); -- Each register holds 32 bit information
			AddrRA	:	in std_logic_vector(4 downto 0);
			AddrRB	:	in std_logic_vector(4 downto 0);
			OutA	:	out signed(31 downto 0);
			OutB	:	out signed(31 downto 0)
			);
end RegisterFile;

architecture register_file of RegisterFile is

type registers is array(0 to 31) of signed(31 downto 0);

signal Data_Register : registers ;



--------------- BEGIN -----------------------------------------------------------------
begin
-- rw='1' alors lecture
	access_register:process(rst, clk)
		begin
		
		if rst='1' then
		
			for k in 0 to 31 loop
				Data_Register(k) <= (others=>'0');
			end loop;
		
		else
			if rising_edge(clk) then
				if en='1' then
					if(rw='1') then 
						OutA <= Data_Register(to_integer(unsigned(AddrRA)));
						OutB <= Data_Register(to_integer(unsigned(AddrRB)));
					else
						Data_Register(to_integer(unsigned(Addr))) <= Data_in;
					end if;
				end if;
			end if;
		end if;
		
	end process access_register;

end register_file;