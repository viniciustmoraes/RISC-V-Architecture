library ieee;
 
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
 
entity DisplayDecoder is
	port(
            InputData: in std_logic_vector(15 downto 0); 
            Display1: out std_logic_vector(3 downto 0);
            Display2: out std_logic_vector(3 downto 0);
            Display3: out std_logic_vector(3 downto 0);
            Display4: out std_logic_vector(3 downto 0)
			);
end DisplayDecoder;
 
 
architecture display_decoder of DisplayDecoder is
    begin
 
    Display4 <= InputData(15 downto 12);
    Display3 <= InputData(11 downto 8);
    Display2 <= InputData(7 downto 4);
    Display1 <= InputData(3 downto 0);
 
 
    end display_decoder;