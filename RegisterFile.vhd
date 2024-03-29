library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity RegisterFile is
	port(
			clk: in std_logic;
			Addr: in std_logic_vector(4 downto 0);  -- 32 registers, therefore 5 bit addresses
			we: in std_logic; -- Write Enable (we)
			rst: in std_logic; -- Reset (rst)
			Data_in: in std_logic_vector(31 downto 0); -- Each register holds 32 bit information
			AddrRA, AddrRB: in std_logic_vector(4 downto 0);
			OutA, OutB:	out std_logic_vector(31 downto 0);
			selrp: in std_logic_vector(1 downto 0); -- Select actualisation of register stack pointer
			AddrDisplay: in std_logic_vector(4 downto 0); -- for fpga board interface
			OutDisplay:	out std_logic_vector(31 downto 0) -- idem
			);
end RegisterFile;

architecture register_file of RegisterFile is

type regfiletype is array(0 to 31) of std_logic_vector(31 downto 0);

signal Data_Register: regfiletype;

begin
-- two read addresses (AddrRA, AddrRB) -> (OutA, OutB)
-- one write address (Addr) <- Data_in

-- reads combinationally (asynchronous)
-- writes on rising edge of clock (synchronous)

-- register x0 (zero) hardwired to 0
-- rst signal resets all registers

	writing:
	process(rst, clk) begin		
		if rst='1' then
			for k in 0 to 31 loop
				Data_Register(k) <= (others=>'0');
			end loop;
		else
			if rising_edge(clk) then
				if selrp = "01" then
					Data_Register(2) <= std_logic_vector(signed(Data_Register(2)) - 1);
				end if;
				if selrp = "10" then
					Data_Register(2) <= std_logic_vector(signed(Data_Register(2)) + 1);
				end if;
				if we='1' then
					Data_Register(to_integer(unsigned(Addr))) <= Data_in;
				end if;
			end if;
		end if;
	end process writing;
	
	reading:
	process(AddrRA, AddrRB) begin
		if (AddrRA = b"00000") then
			OutA <= x"00000000"; -- address x0 always outputs 0
		else
			OutA <= Data_Register(to_integer(unsigned(AddrRA)));
		end if;
		if (AddrRB = b"00000") then
			OutB <= x"00000000"; -- address x0 always outputs 0
		else
			OutB <= Data_Register(to_integer(unsigned(AddrRB)));
		end if;
	end process reading;
	

	displayReading:
	process(AddrDisplay) begin
		if (AddrDisplay = b"00000") then
			OutDisplay <= x"00000000"; -- address x0 always outputs 0
		else
			OutDisplay <= Data_Register(to_integer(unsigned(AddrDisplay)));
		end if;
	end process displayReading;

end register_file;