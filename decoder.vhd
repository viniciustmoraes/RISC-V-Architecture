library ieee;

use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
	port(
			clk		        :	in std_logic;
			Status          :   in std_logic_vector(2 downto 0); -- Status from ALU (3 bits: CarryOut, isZero, isPositive)
            Instruction     :   in std_logic_vector(31 downto 0); -- Instructions coming from ROM

            SelOp : out std_logic_vector(3 downto 0); -- Selects operation to perform in the ALU
            SelMuxRam : out std_logic; -- Selects whether to use value from RAM or from ALU
            SelMuxImm : out std_logic; -- Selects whether to use an immediate or OutB from the RegisterFile in the ALU

            Imm : out signed(31 downto 0); -- Immediate given in the instruction

            AddrRAM : out std_logic_vector(31 downto 0); -- Address to be accessed in the RAM

            PC_load	        :	out std_logic;	-- Determines if a JUMP operation is taking place
			PC_Jump	        :	out std_logic_vector(7 downto 0);	-- In case of a JUMP operation, specifies the destination

            EnRegFile, EnRAM, EnROM     :   out std_logic;
            rwRegFile, rwRAM            :   out std_logic;
            AddrRA, AddrRB  :   out std_logic_vector(4 downto 0); -- Addresses of RA and RB in the RegisterFile (read)
            AddrRdest : out std_logic_vector(4 downto 0) -- Address of Rdest in the RegisterFile (store)
            );
end decoder;

architecture Decoder of decoder is

-- Beginning of the code
signal OpCode : std_logic_vector(5 downto 0);
signal Format : std_logic_vector(1 downto 0);
signal Operator : std_logic_vector(3 downto 0);

begin

    OpCode <= Instruction(5 downto 0);
    Format <= OpCode(1 downto 0);
    Operator <= OpCode(5 downto 2);

    process(clk) begin
        if rising_edge(clk) then
            -- Synchronous outputs
            case(Format) is
                when "00" =>
                    AddrRdest <= Instruction(10 downto 6);
                    AddrRA <= Instruction(15 downto 11);
                    AddrRB <= Instruction(20 downto 16);
                    
                    case(Operator) is
                        -- todo
                    end case;
                when "01" =>
                    AddrRdest <= Instruction(10 downto 6);
                    AddrRA <= Instruction(15 downto 11);
                    Imm <= Instruction(28 downto 16);

                    case(Operator) is
                        -- todo
                    end case;
                when "10" =>
                    -- not used
                    -- only here to avoid latch
                    abc
                when "11" =>
                    AddrRAM <= Instruction(13 downto 6);
                    AddrRA <= Instruction(18 downto 14);
                    AddrRB <= Instruction(23 downto 19);

                    case(Operator) is
                        -- todo
                    end case;
            end case;

        end if;
    end process;

end architecture Decoder;