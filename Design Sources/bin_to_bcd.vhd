----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: bin_to_bcd - Behavioral
-- Description: This module uses the Double dabble algorithm for converting
-- binary to BCD. It takes the number that needs to be displayed and outputs
-- the four digits of said number.
--
-- Implementation inspired by this Wikipedia article:
-- https://wikipedia.org/w/index.php?title=Double_dabble&oldid=997863872#VHDL_implementation.
--
-- Code based on bin_to_bcd.vhd example file provided for the ENEL373 course at UC
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_to_bcd is
    generic (
        SEG_SIZE : integer := 4; -- Length of binary input (number of bits per segment)
        BITS : integer := 12;    -- Number of segments (total number of bits)
        DIGITS : integer := 4   -- Vector size for each segment (number of BCD digits)
    );
    Port (
        DisplayNum : in STD_LOGIC_VECTOR (11 downto 0);  -- Binary number to be converted to BCD
        clk : in std_logic;                              -- Clock input
        num1, num2, num3, num4 : out STD_LOGIC_VECTOR (3 downto 0); -- BCD digits output
        state : in STD_LOGIC_VECTOR (1 downto 0)         -- State input
    );
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is
begin
    process(clk)
        variable bin_reg : std_logic_vector (BITS - 1 downto 0);      -- Register to hold the binary input
        variable bcd_reg : unsigned (DIGITS * SEG_SIZE - 1 downto 0); -- Register to hold the BCD representation
        variable count   : integer;                                   -- Counter variable
    begin
        if rising_edge(clk) then
            bin_reg := DisplayNum;      -- Load the binary input into bin_reg
            bcd_reg := (others => '0'); -- Initialize bcd_reg to all zeros
            count   := 0;               -- Initialize the counter variable to 0
            
            while (count < BITS) loop
                -- Loop through all BCD digits
                for i in 0 to digits - 1 loop
                    -- Add 3 to place values (digits) if they are greater than 4
                    if bcd_reg(i * 4 + 3 downto i * 4) > 4 then
                        bcd_reg(i * 4 + 3 downto i * 4) := bcd_reg(i * 4 + 3 downto i * 4) + 3;
                    end if;
                end loop;
        
                -- Shift registers right
                bcd_reg := bcd_reg(digits * 4 - 2 downto 0) & bin_reg(bits - 1);  -- Shift bcd_reg and append the most significant bit of bin_reg
                bin_reg := bin_reg(bits - 2 downto 0) & '0';                      -- Shift bin_reg right and append a '0' at the leftmost bit
                count := count + 1;                                                -- Increment the counter
            end loop;
            
            num1 <= std_logic_vector(bcd_reg(3 downto 0));     -- Output the first BCD digit
            num2 <= std_logic_vector(bcd_reg(7 downto 4));     -- Output the second BCD digit
            num3 <= std_logic_vector(bcd_reg(11 downto 8));    -- Output the third BCD digit
            num4 <= std_logic_vector(bcd_reg(15 downto 12));   -- Output the fourth BCD digit
        end if;
    end process;
end Behavioral;