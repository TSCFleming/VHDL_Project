----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: BCD_to_7SEG - Behavioral
-- Description: This module converts a BCD to the output needed for a 7-Segment display
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BCD_to_7SEG is
    Port (
        bcd_in: in std_logic_vector (4 downto 0);     -- Input BCD vector
        leds_out: out std_logic_vector (1 to 7)        -- Output 7-Segment vector
    );
end BCD_to_7SEG;

architecture Behavioral of BCD_to_7SEG is
begin
    my_seg_proc: process (bcd_in)      -- Enter this process whenever BCD input changes state
    begin
        case bcd_in is                   -- abcdefg segments
            when "00000"   => leds_out <= "0000001";   -- 0 and O   -- if BCD is "0000" write a zero to display
            when "00001"   => leds_out <= "1001111";   -- 1         -- etc...
            when "00010"   => leds_out <= "0010010";   -- 2
            when "00011"   => leds_out <= "0000110";   -- 3
            when "00100"   => leds_out <= "1001100";   -- 4
            when "00101"   => leds_out <= "0100100";   -- 5
            when "00110"   => leds_out <= "1100000";   -- 6
            when "00111"   => leds_out <= "0001111";   -- 7
            when "01000"   => leds_out <= "0000000";   -- 8
            when "01001"   => leds_out <= "0001100";   -- 9
            when "01111"   => leds_out <= "1111111";   -- Blank
            when "10001"   => leds_out <= "1100011";   -- v
            when "10010"   => leds_out <= "0110000";   -- E
            when "10011"   => leds_out <= "1111010";   -- r
            when "10100"   => leds_out <= "0111000";   -- F
            when "10101"   => leds_out <= "1110001";   -- L
            when "11110"   => leds_out <= "1111110";   -- -
            when others    => leds_out <= "-------";   -- Default case for any other BCD value
        end case;
    end process my_seg_proc;
end Behavioral;