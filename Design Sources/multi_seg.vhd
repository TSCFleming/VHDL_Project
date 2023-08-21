----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: multi_seg - Behavioral
-- Description: This module is a multiplexer which determines which character
-- is displayed on which 7-segment display
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity multi_seg is
    Port (
        dig1, dig2, dig3, dig4, dig5, dig6, dig7 : in STD_LOGIC_VECTOR (3 downto 0); -- Input signals for digit values
        clk, digSign, overflow_ERROR : in STD_LOGIC; -- Input signals for clock, digit sign, and overflow error
        bcd : out STD_LOGIC_VECTOR (4 downto 0); -- Output BCD value for current digit
        disp : out STD_LOGIC_VECTOR (7 downto 0) -- Output value for 7-segment display
    );
end multi_seg;

architecture Behavioral of multi_seg is

    signal pos: std_logic_vector(2 downto 0); -- Signal for keeping track of the current digit position
    signal V : std_logic_vector(4 downto 0); -- Signal for temporary storage of the digit value                   
    signal digit1, digit2, digit3, digit4, digit5, digit6, digit7, digit8 : std_logic_vector(4 downto 0) := "11111"; -- Signals for storing the digit values
    
begin

    process (clk)
    begin
        if (clk'event and clk = '1') then
           
           if (overflow_ERROR = '1') then
                digit7 <= "00000"; -- Set digit7 to display '0'
                digit6 <= "10001"; -- Set digit6 to display 'v'
                digit5 <= "10010"; -- Set digit5 to display 'E'
                digit4 <= "10011"; -- Set digit4 to display 'r'
                digit3 <= "10100"; -- Set digit3 to display 'F'
                digit2 <= "10101"; -- Set digit2 to display 'l'
                digit1 <= "00000"; -- Set digit1 to display '0'
           else
                V <= "00000";
                digit1 <= V + dig1;  -- Add the input digit value to V and store in digit1
                digit2 <= V + dig2;  -- Add the input digit value to V and store in digit2
                digit3 <= V + dig3;  -- Add the input digit value to V and store in digit3
                digit4 <= V + dig4;  -- Add the input digit value to V and store in digit4
                digit5 <= V + dig5;  -- Add the input digit value to V and store in digit5
                digit6 <= V + dig6;  -- Add the input digit value to V and store in digit6
                digit7 <= V + dig7;  -- Add the input digit value to V and store in digit7
                digit8 <= "01111";  -- Set digit8 to display a blank segment
                if (digSign = '1') then
                    digit8 <= "11110";  -- Set digit8 to display '-' if digSign is '1'
                end if;
           end if;
           case pos is
                when "000" =>
                    bcd <= digit1;  -- Assign digit1 value to the BCD output
                    disp <= "11111110";  -- Set the display output to show the digit1 pattern
               when "001" =>
                    bcd <= digit2;  -- Assign digit2 value to the BCD output
                    disp <= "11111101";  -- Set the display output to show the digit2 pattern
                when "010" =>
                    bcd <= digit3;  -- Assign digit3 value to the BCD output
                    disp <= "11111011";  -- Set the display output to show the digit3 pattern
                when "011" =>
                    bcd <= digit4;  -- Assign digit4 value to the BCD output
                    disp <= "11110111";  -- Set the display output to show the digit4 pattern
                when "100" =>
                    bcd <= digit5;  -- Assign digit5 value to the BCD output
                    disp <= "11101111";  -- Set the display output to show the digit5 pattern
                when "101" =>
                    bcd <= digit6;  -- Assign digit6 value to the BCD output
                    disp <= "11011111";  -- Set the display output to show the digit6 pattern
                when "110" =>
                    bcd <= digit7;  -- Assign digit7 value to the BCD output
                    disp <= "10111111";  -- Set the display output to show the digit7 pattern
                when "111" =>
                    bcd <= digit8;  -- Assign digit8 value to the BCD output
                    disp <= "01111111";  -- Set the display output to show the digit8 pattern
                when others =>
                    bcd <= "00000";  -- Clear the BCD output for invalid positions
                    disp <= "00000000";  -- Clear the display output for invalid positions
           end case;
           if (pos = "111") then
                pos <= "000";  -- Reset the position to the first digit position
           else
                pos <= pos + 1;  -- Increment the position to the next digit position
           end if;
        end if;
    end process;
    
end Behavioral;