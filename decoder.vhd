library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity decoder is
	port(
		clk		       :	in std_logic;
		Status          :   in std_logic_vector(2 downto 0); -- Status from ALU (3 bits: CarryOut, isZero, isPositive)
		PC_now          :   in std_logic_vector(7 downto 0);
        Instruction     :   in std_logic_vector(31 downto 0); -- Instructions coming from ROM

        SelOp : out std_logic_vector(3 downto 0); -- Selects operation to perform in the ALU
        SelMuxRam : out std_logic; -- Selects whether to use value from RAM or from ALU
        SelMuxImm : out std_logic; -- Selects whether to use an immediate or OutB from the RegisterFile in the ALU
            
		Imm : out signed(31 downto 0); -- Immediate given in the instruction

        AddrRAM : out std_logic_vector(7 downto 0); -- Address to be accessed in the RAM
			
        PC_load	        :	out std_logic;	-- Determines if a JUMP operation is taking place
		PC_Jump	        :	out std_logic_vector(7 downto 0);	-- In case of a JUMP operation, specifies the destination

        EnRegFile, EnRAM, EnROM     :   out std_logic;
        rRegFile, wRegFile, rRAM, wRAM   :   out std_logic;
        AddrRA, AddrRB              :   out std_logic_vector(4 downto 0); -- Addresses of RA and RB in the RegisterFile (read)
        AddrRdest                   : out std_logic_vector(4 downto 0) -- Address of Rdest in the RegisterFile (store)
        
		);
		  
end entity decoder;

architecture Decoder of decoder is

-- Beginning of the code
signal OpCode : std_logic_vector(5 downto 0);
signal Format : std_logic_vector(1 downto 0);
signal Operator : std_logic_vector(3 downto 0);
signal OldImm : signed(11 downto 0);
signal EnTmpRam : std_logic;
signal EnTmpRom : std_logic;
signal EnTmpRegFile : std_logic;

begin

    OpCode <= Instruction(5 downto 0);
    Format <= OpCode(1 downto 0);
    Operator <= OpCode(5 downto 2);

    -- Enable components
    EnTmpRam <= '1';
    EnTmpRegFile <= '1';
    EnTmpRom <= '1';

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
                    
                    end if;

                when "01" => -- Format using 1 register data and 1 immediate for computations

                    if Operator = "1001" then -- Case instruction is NOP
                        NULL; -- See further after

                    elsif Operator = "1000" then -- Case instruction is CLR

                        -- Setting up addresses of writing and reading
                        AddrRdest <= Instruction(10 downto 6);

                        -- Setting up control signals for MUXs, ALU and RegisterFile
                        SelOp <= Operator;
                        SelMuxRam <= '0';
                        rRegFile <= '0';
                        wRegFile <= '1'; -- Needs flip-flop (second cicle)

                    else

                        -- Setting up addresses of writing and reading
                        AddrRdest <= Instruction(10 downto 6);
                        AddrRA <= Instruction(15 downto 11);
						OldImm <= signed(Instruction(27 downto 16));
						Imm <= resize (OldImm, 32);
								
                        -- Setting up control signals for MUXs, ALU and RegisterFile
                        SelOp <= Operator; -- Needs flip-flop (second cicle)
                        SelMuxRam <= '0';
                        SelMuxImm <= '1';
                        rRegFile <= '1';
                        wRegFile <= '1'; -- Needs flip-flop (second cicle)


                    end if;
                    
                when "10" =>
                    -- not used
                    -- only here to avoid latch
                    NULL;
                
                when "11" => 
                    -- Setting up addresses of writing and reading
                    AddrRAM <= Instruction(13 downto 6);
                    AddrRA <= Instruction(18 downto 14);
                    AddrRB <= Instruction(23 downto 19);
                    PC_Jump <= Instruction(31 downto 24);


                    case(Operator) is
                        when "0111" => -- SW --> NEDS CORRECTION OF SYNC
                            -- Setting up control signals
                            -- For SW we need to save an word in the RAM

                            rRegFile <= '1';
                            wRegFile <= '0'; -- Needs flip-flop (second cicle)
                            rRAM <= '0';
                            wRAM <= '1'; -- Needs flip-flop (second cicle)
                            PC_load <= '0';

                        when "0110" => -- LW
                            -- Setting up control signals
                            -- For LW we need to load an word into the register

                            rRegFile <= '0';
                            wRegFile <= '1'; -- Needs flip-flop (second cicle)

                            rRAM <= '1';
                            wRAM <= '0'; -- Needs flip-flop (second cicle)

                            PC_load <= '0';


                        
                        when "0011" => -- Jump
                            -- Setting up control signals
                            -- Traditional jump requires passing to a new line of ROM in the instructions

                            -- Do the jump
                            PC_load <= '1';              

                        when "0100" => -- JAL(CALL)
                            -- Setting up control signals
                            -- Traditional jump requires passing to a new line of ROM in the instructions

                            -- MOV the address to register
                            Imm <= resize(signed(PC_now),32);
                            SelMUXImm <= '1';
                            SelMUXRam <= '0';

                            SelOp <= "1101"; -- MOV Imm in ALU exclusive to this function
                            AddrRdest <= "00000"; -- Reserved address to jump calls !

                            wRegFile <= '1'; -- Needs flip-flop (second cicle)
                            rRegFile <= '0';

                            rRAM <= '0';
                            wRAM <= '0'; -- Needs flip-flop (second cicle)

                            -- Do the jump
                            PC_load <= '1';

                            

                        when "0101" => -- JARL (RET) -->NEEDS CORRECTION
                            -- Setting up control signals
                            -- Consists of jumping to the last line of instructions before jumping + 1

                            -- Acquiring PC+1
                            rRegFile <= '1';
                            wRegFile <= '0'; -- Needs flip-flop (second cicle)

                            PC_load <= '1';
                            
								
						when others => NULL;
                        
                        
                        
                    end case;
            end case;

        end if;
    end process;

    EnROM <= EnTmpRom;
    EnRAM <= EnTmpRam;
    EnRegFile <= EnTmpRegFile;
end architecture Decoder;