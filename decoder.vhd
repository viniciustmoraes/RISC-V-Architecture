library ieee;

use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
	port(
			clk		        :	in std_logic;
            RegA, RegB      :   in std_logic_vector(31 downto 0);
			Status          :   in std_logic_vector(1 downto 0); -- VERIFICAR COM O CÓDIGO DA ALU 
            Instruct        :   in std_logic_vector(31 downto 0); -- Instructions coming from ROM


            PC_load	        :	out std_logic;	-- Determines if a JUMP operation is taking place
			PC_Jump	        :	out std_logic_vector(7 downto 0);	-- In case of a JUMP operation, specifies the destination
            EnRegFile, EnRAM, EnROM     :   out std_logic;
            rwRegFile, rwRAM            :   out std_logic;
            AddrRA, AddrRB  :   out std_logic_vector(4 downto 0);
            A,B             :   out std_logic_vector(31 downto 0) --;
--            SelR            :   out std_logic_vector(? downto 0);    ------> VERIFICAR COM ANINHA
            );
end decoder;

architecture Decoder of decoder is

-- Beginning of the code

begin
    
end Decoder;