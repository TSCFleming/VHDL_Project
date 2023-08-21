----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: Registor_2bit - Behavioral
-- Description: This module is the register for the 2-bit opcode
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registor_2bit is
    Port (
        variable_in : in STD_LOGIC_VECTOR (1 downto 0);  -- Input signal for the 2-bit value
        capture, clock : in STD_LOGIC;  -- Capture and clock signals
        output : out STD_LOGIC_VECTOR (1 downto 0)  -- Output signal for the stored value
    );
end Registor_2bit;

architecture Behavioral of Registor_2bit is

    signal storage: std_logic_vector (1 downto 0);  -- Internal storage signal for the 2-bit value

begin
    capture_input: process(capture, clock, variable_in)
    begin
        if (rising_edge(clock) and capture = '1') then  -- Capture the input value on the rising edge of the clock when capture signal is '1'
            storage <= variable_in;  -- Store the input value into the storage signal
            output <= storage;  -- Output the stored value
        end if;
    end process capture_input;

end Behavioral;