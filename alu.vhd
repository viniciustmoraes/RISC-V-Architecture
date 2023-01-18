library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity ALU is
	port(
			X,Y 	:	in signed(31 downto 0); -- Sign-extended 32-bit entries from the Register File or Immediate
			SelOp	:	in std_logic_vector(3 downto 0); -- Selection of ALU operation
			OutALU	:	out signed(31 downto 0); -- Output of the operation choosen
         	Status  :   out std_logic_vector(2 downto 0) -- Status output (P: positive output, Z: nul output)
			);
end ALU;

Architecture alu of ALU is

signal ResultALU : signed(31 downto 0); -- Output before treatment
signal CarryOut : std_logic;
signal P : std_logic;
signal Z : std_logic;
signal tmp : signed(32 downto 0);
--------------- BEGIN -----------------------------------------------------------------
Begin

Process(X,Y,SelOp,ResultALU)
		begin
			tmp <= (others => '0');
			case(SelOp) is -- Selection of the operation done by the ALU between the preset functions in the ISA
				when "0000" =>
				tmp <= resize(X,tmp'length) + resize(Y,tmp'length);
				ResultALU <= tmp(31 downto 0); -- ADD
				when "0001" => 
				tmp <= resize(X,tmp'length) - resize(Y,tmp'length);
				ResultALU <= tmp(31 downto 0); -- SUB
				when "0010" => ResultALU <= X and Y; -- AND
				when "0011" => ResultALU <= X or Y; -- OR
				when "0100" => ResultALU <= X xor Y; -- XOR
				when "0101" => ResultALU <= not X; -- NOT A (I realized that having 2 NOTs is stupid so maybe supress one)
				when "0110" => ResultALU <= not Y; -- NOT B
				when "0111" => ResultALU <= to_signed((to_integer(X)*to_integer(Y)),32); -- MUL (maybe treat carryout for this as well?)
				when "1000" => ResultALU <= (others => '0'); -- CLR
				when "1001" => ResultALU <= (others => '0'); -- NOP (do nothing)
				when "1010" => ResultALU <= X; -- MOV
				when "1011" => ResultALU <= signed(unsigned(X) sll to_integer(Y)); -- SLLI
				when "1100" => ResultALU <= signed(unsigned(X) srl to_integer(Y)); -- SRLI
				when others => ResultALU <= (others => '0'); -- do nothing
			
			-- Obs: Some ISA functions are not described because they use these functions in their process
			-- Examples: Conditional jumps, jump, write and read from RAM.

			end case;

			-- Treating Status components
			Carryout <= std_logic(tmp(32)); -- Carryout from sum or sub
			
			if (to_integer(ResultALU) >= 0) then
			P <= '1';
			else
			P <= '0';
			end if;
			
			if (to_integer(ResultALU) = 0) then
			Z <= '1';
			else
			Z <= '0';
			end if;

	end Process;
	
	OutALU <= ResultALU;
	Status(0) <= P; -- P: verifies if the Output is positive
    Status(1) <= Z; -- Z: verifies if the Output is zero
    Status(2) <= Carryout; -- C: Carryout from sum our substraction operators

end Architecture alu;