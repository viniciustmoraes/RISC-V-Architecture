library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mux2_sync is
	port(
			clk		        :	in std_logic;
            data_in0, data_in1 : in signed(31 downto 0);
            selMux : in std_logic;
            data_out : out signed(31 downto 0)
            );
end mux2_sync;

architecture synth of mux2_sync is

-- Beginning of the code

begin

    process(clk) begin
        if rising_edge(clk) then
            -- Synchronous outputs
            if selMux = '0' then
                data_out <= data_in0;
            else
                data_out <= data_in1;
            end if;
        end if;
    end process;
    
end architecture synth;