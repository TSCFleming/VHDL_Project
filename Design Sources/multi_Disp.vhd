----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: multi_Disp - Behavioral
-- Description: This module is a multiplexer that either displays the answer
-- from the ALU or the state of the switches
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi_Disp is
    Port (
        SW : in STD_LOGIC_VECTOR (15 downto 0);      -- Input switches
        Answer : in STD_LOGIC_VECTOR (12 downto 0);  -- Input answer from the ALU
        numOut : out STD_LOGIC_VECTOR (11 downto 0); -- Output number to display
        sign : out STD_LOGIC;                        -- Output sign to display
        State : in STD_LOGIC_VECTOR (1 downto 0)      -- Input state
    );
end multi_Disp;

architecture Behavioral of multi_Disp is
begin
    process (State)
    begin
        if (State = "10") then
            numOut <= Answer(11 downto 0);  -- Output the lower 12 bits of the answer from the ALU
            sign <= Answer(12);             -- Output the sign bit of the answer from the ALU
        else
            numOut <= SW(11 downto 0);      -- Output the lower 12 bits of the input switches
            sign <= SW(15);                 -- Output the sign bit of the input switches
        end if;
    end process;
end Behavioral;