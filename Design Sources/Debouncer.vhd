----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: Debouncer - Behavioral
-- Description: This module debounces the up, down, left, right, and center buttons
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Port (
        BTNC, BTNU, BTND, BTNL, BTNR: in STD_LOGIC;     -- Input buttons
        CLK_100MHZ : in STD_LOGIC;                       -- Clock input
        BTNC_D, BTNU_D, BTND_D, BTNL_D, BTNR_D : out STD_LOGIC -- Debounced button outputs
    );
end Debouncer;

architecture Behavioral of Debouncer is
    signal Buttons, Debounced_BTN, a, b, c, d, e, f, g : std_logic_vector (4 downto 0); -- Signals for debouncing
    
begin
    process(CLK_100MHZ)
    begin
        Buttons <= BTNC & BTNU & BTND & BTNL & BTNR;  -- Concatenate input buttons
        
        if ((Buttons /= 0) AND (CLK_100MHZ'Event) and (CLK_100MHZ = '1')) THEN
            -- Debouncing process
            a <= Buttons;   -- Store current button values
            b <= a;         -- Delay by one clock cycle
            c <= b;         -- Delay by one clock cycle
            d <= c;         -- Delay by one clock cycle
            e <= d;         -- Delay by one clock cycle
            f <= e;         -- Delay by one clock cycle
            g <= f;         -- Delay by one clock cycle
        end if;
    end process;
    
    Debounced_BTN <= a and b and c and d and e and f and g and Buttons;  -- Debounced button values
    
    BTNC_D <= Debounced_BTN(4);  -- Output debounced center button
    BTNU_D <= Debounced_BTN(3);  -- Output debounced up button
    BTND_D <= Debounced_BTN(2);  -- Output debounced down button
    BTNL_D <= Debounced_BTN(1);  -- Output debounced left button
    BTNR_D <= Debounced_BTN(0);  -- Output debounced right button
    
end Behavioral;