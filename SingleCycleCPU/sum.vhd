library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity sum is

	port(
			In1	:	in std_logic_vector(4 downto 0);
			Out1 :	out std_logic_vector(31 downto 0)
			);
end sum;

architecture sum_a of sum is

begin
	Out1 <= std_logic_vector(resize((unsigned(In1) + 1),32));
	


end sum_a;
