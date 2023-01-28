library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity inc is

	port(
			In1	:	in std_logic_vector(4 downto 0);
			Out1 :	out std_logic_vector(4 downto 0)
			);
end inc;

architecture inc_a of inc is

begin
	Out1 <= std_logic_vector(signed(In1) + 1);
	


end inc_a;
