----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: ALU - Behavioral
-- Description: This module performs the arithmetic logic for the given inputs
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        NUM1, NUM2 : in STD_LOGIC_VECTOR (12 downto 0);    -- Input operands
        Operator, state : in STD_LOGIC_VECTOR (1 downto 0); -- Operator and state inputs
        Result : out STD_LOGIC_VECTOR (12 downto 0);       -- Result output
        Overflow : out STD_LOGIC                           -- Overflow flag output
    );
end ALU;

architecture Behavioral of ALU is
    signal long_Result : STD_LOGIC_VECTOR (23 downto 0);   -- Used for multiplication result
    signal numOne, numTwo, numAnswer, numResult : std_logic_vector(12 downto 0); -- Intermediate signals for calculations
    signal numOneBig, numTwoBig : std_logic_vector(14 downto 0); -- Used for overflow detection
    
begin
    process (state)
    begin
        if (state = "00") then
            Overflow <= '0';  -- Clear overflow flag when in state "00"
        elsif (state = "10") then
            if (NUM1(12) = '1') then
                numOne <= (NUM1 xor "0111111111111") + '1';  -- Convert NUM1 from two's complement to signed representation
                numOneBig(14 downto 13) <= "11";
            else
                numOne <= NUM1;
                numOneBig(14 downto 13) <= "00";
            end if;
            if (NUM2(12) = '1') then
                numTwo <= (NUM2 xor "0111111111111") + '1';  -- Convert NUM2 from two's complement to signed representation
                numTwoBig(14 downto 13) <= "11";
            else
                numTwo <= NUM2;
                numTwoBig(14 downto 13) <= "00";
            end if;

            numOneBig(12 downto 0) <= numOne;  -- Store the lower 13 bits of numOne in numOneBig
            numTwoBig(12 downto 0) <= numTwo;  -- Store the lower 13 bits of numTwo in numTwoBig
            
            case (Operator) is
                when "00" => -- Addition  
                    -- Check for overflow by comparing the sum with the range [-4096, 4095]
                    if ((numOneBig + numTwoBig) < 4096) and ((numOneBig + numTwoBig) > -4096) then
                        Overflow <= '0';  -- No overflow
                        numAnswer <= (numOne + numTwo);  -- Perform addition
                        if (numAnswer(12) = '1') then
                            numResult <= (numAnswer xor "0111111111111") + '1';  -- Convert the result back to two's complement if necessary
                        else
                            numResult <= numAnswer;
                        end if;
                        Result <= numResult;  -- Set the result
                    else 
                        Overflow <= '1';  -- Overflow occurred
                    end if;
                    
                when "01" => -- Subtraction
                    -- Check for overflow by comparing the difference with the range [-4096, 4095]
                    if ((numOneBig - numTwoBig) < 4096) and ((numOneBig - numTwoBig) > -4096) then
                        Overflow <= '0';  -- No overflow
                        numAnswer <= (numOne - numTwo);  -- Perform subtraction
                        if (numAnswer(12) = '1') then
                            numResult <= (numAnswer xor "0111111111111") + '1';  -- Convert the result back to two's complement if necessary
                        else
                            numResult <= numAnswer;
                        end if;
                        Result <= numResult;  -- Set the result
                    else
                        Overflow <= '1';  -- Overflow occurred
                    end if;
                    
                when "10" => -- Multiplication
                    long_Result <= std_logic_vector(signed(NUM1(11 downto 0)) * signed(NUM2(11 downto 0)));  -- Perform multiplication
                    if (signed(long_Result) < 4096) then 
                        Overflow <= '0';  -- No overflow
                        Result(11 downto 0) <= long_Result(11 downto 0);  -- Store the lower 12 bits of the multiplication result
                        Result(12) <= NUM1(12) xor NUM2(12);  -- Determine the sign of the result
                    else 
                        Overflow <= '1';  -- Overflow occurred
                    end if;
                    
                when others =>  -- Extra case for handling other operators
                    Overflow <= '0';  -- Clear overflow flag
                    numTwo(12) <= '0';  -- Set the sign bit of numTwo to 0
                    Result <= std_logic_vector(signed(numOne) mod signed(numTwo));  -- Perform modulo operation and store the result
            end case;
        end if;
    end process;
end Behavioral;