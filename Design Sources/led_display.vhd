----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: led_display - Behavioral
-- Description: This module determines the logic for the LED array and RGB LEDs.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led_display is
    Port (
        Reg1 : in STD_LOGIC_VECTOR (12 downto 0);    -- Input for register 1
        Reg2 : in STD_LOGIC_VECTOR (12 downto 0);    -- Input for register 2
        State : in STD_LOGIC_VECTOR (1 downto 0);    -- State input
        Opcode : in STD_LOGIC_VECTOR (1 downto 0);   -- Opcode input
        LED_array : out STD_LOGIC_VECTOR (15 downto 0);  -- Output for the LED array
        LED16_B, LED16_G, LED16_R, LED17_B, LED17_G, LED17_R : out STD_LOGIC  -- Outputs for RGB LEDs
    );
end led_display;

architecture Behavioral of led_display is
begin

process(state) 
begin
    if (state = "00") then
        LED16_R <= '1';  -- Turn on LED16_R (Red) and turn off the others
        LED16_G <= '0';
        LED16_B <= '0';
        LED_array <= (others => '0');  -- Turns off the LED array when in the initial state.
    elsif (state = "01") then
        LED16_R <= '0';  -- Turn off LED16_R (Red) and turn on LED16_G (Green)
        LED16_G <= '1';
        LED16_B <= '0';
        LED_array <= Opcode & "0" &  Reg1;  -- Displays the number in the first register and the operator.
    elsif (state = "10") then
        LED16_R <= '0';  -- Turn off LED16_R (Red) and LED16_G (Green), and turn on LED16_B (Blue)
        LED16_G <= '0';
        LED16_B <= '1';
        LED_array <= Opcode & "0" & Reg2;  -- Displays the number in the second register and the operator.
    end if;
end process;

end Behavioral;