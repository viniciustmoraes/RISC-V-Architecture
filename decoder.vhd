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
            rRegFile, wRegFile, rwRAM            :   out std_logic;
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
                when "00" => -- Format using 2 register datas for computations
                    if Operator = "1001" then -- Case instruction is NOP
                        NULL; -- See further after
                    
                    elsif Operator = "1000" then -- Case instruction is CLR

                        -- Setting up addresses of writing and reading
                        AddrRdest <= Instruction(10 downto 6);

                        -- Setting up control signals for MUXs, ALU and RegisterFile
                        SelOp <= Operator; -- Needs flip-flop (second cicle)
                        SelMuxRam <= '0';
                        rRegFile <= '0';
                        wRegFile <= '1'; -- Needs flip-flop (second cicle)

                        -- Enable of components
                        EnRegFile <= '1';
                        EnRAM <= '0';

                    else

                        -- Setting up addresses of writing and reading
                        AddrRdest <= Instruction(10 downto 6);
                        AddrRA <= Instruction(15 downto 11);
                        AddrRB <= Instruction(20 downto 16);
                        
                        -- Setting up control signals for MUXs, ALU and RegisterFile
                        SelOp <= Operator; -- Needs flip-flop (second cicle)
                        SelMuxRam <= '0';
                        SelMuxImm <= '0';
                        rRegFile <= '1';
                        wRegFile <= '1'; -- Needs flip-flop (second cicle)

                        -- Enable of components
                        EnRegFile <= '1';
                        EnRAM <= '0';
                    
                    end if;

                when "01" => -- Format using 1 register data and 1 immediate for computations

                    if Operator = "1001" then -- Case instruction is NOP
                        NULL; -- See further after

                    elsif Operator = "1000" then -- Case instruction is CLR

                        -- Setting up addresses of writing and reading
                        AddrRdest <= Instruction(10 downto 6);

                        -- Setting up control signals for MUXs, ALU and RegisterFile
                        SelOp <= Operator; -- Needs flip-flop (second cicle)
                        SelMuxRam <= '0';
                        rRegFile <= '0';
                        wRegFile <= '1'; -- Needs flip-flop (second cicle)

                        -- Enable of components
                        EnRegFile <= '1';
                        EnRAM <= '0';    

                    else

                        -- Setting up addresses of writing and reading
                        AddrRdest <= Instruction(10 downto 6);
                        AddrRA <= Instruction(15 downto 11);
                        Imm <= resize(Instruction(28 downto 16),32);

                        -- Setting up control signals for MUXs, ALU and RegisterFile
                        SelOp <= Operator; -- Needs flip-flop (second cicle)
                        SelMuxRam <= '0';
                        SelMuxImm <= '1';
                        rRegFile <= '1';
                        wRegFile <= '1'; -- Needs flip-flop (second cicle)

                        -- Enable of components
                        EnRegFile <= '1';
                        EnRAM <= '0';

                    end if;
                    
                when "10" =>
                    -- not used
                    -- only here to avoid latch
                    NULL;
                
                when "11" => 
                    AddrRAM <= Instruction(13 downto 6);
                    AddrRA <= Instruction(18 downto 14);
                    AddrRB <= Instruction(23 downto 19);

                    case(Operator) is
                    end case;
            end case;

        end if;
    end process;

end architecture Decoder;