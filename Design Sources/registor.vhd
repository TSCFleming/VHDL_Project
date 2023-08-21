----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: registor - Behavioral
-- Description: This module is the register for the two 12-bit numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registor is
    Port (
        variable_in : in STD_LOGIC_VECTOR (12 downto 0);  -- Input for the 12-bit number to be stored
        capture, clock : in STD_LOGIC;                     -- Capture signal and clock input
        output : out STD_LOGIC_VECTOR (12 downto 0)        -- Output for the stored 12-bit number
    );
end registor;

architecture Behavioral of registor is
    signal storage : std_logic_vector (12 downto 0);  -- Storage signal for holding the 12-bit number
    
begin
    capture_input: process(capture, clock, variable_in)
    begin
        if (rising_edge(clock) and capture = '1') then  -- Capture the input on the rising edge of the clock when capture signal is high
            storage <= variable_in;                     -- Store the input value into the storage signal
            output <= storage;                           -- Output the stored value
        end if;
    end process capture_input;
end Behavioral;