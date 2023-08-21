----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: state_machine - Behavioral
-- Description: This module determines the state logic for the calculator.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;

entity state_machine is
    port(
        BTNU, BTND, BTNL, BTNR, BTNC : in STD_LOGIC;              -- Button inputs
        Operator, StateOut : out std_logic_vector(1 downto 0);    -- Output signals for operator and state
        clock : in STD_LOGIC                                      -- Clock input
    );
end state_machine;

architecture Behavioral of state_machine is

    signal state, operate : std_logic_vector (1 downto 0) := "00"; -- Internal signals for current state and operator
    signal stateChange : std_logic;                               -- Flag for state change

begin
    process (clock)
    begin
        if rising_edge(clock) then  -- Detect rising edge of the clock
            if state = "00" then -- Display first number
                if (stateChange = '1') then
                    if (BTNU or BTNL or BTNR or BTND) = '0' then
                        stateChange <= '0';  -- Reset stateChange flag when buttons are not pressed
                    end if;
                elsif (BTNU or BTNL or BTNR or BTND) = '1' then
                    if (BTNU = '1') then operate <= "00";end if;   -- Set operator based on button pressed
                    if (BTND = '1') then operate <= "01";end if;
                    if (BTNL = '1') then operate <= "10";end if;
                    if (BTNR = '1') then operate <= "11";end if;  
                    state <= "01";              -- Transition to the next state
                    stateChange <= '1';         -- Set stateChange flag to indicate state transition
                end if;     
            elsif state = "01" then -- Display Second number
                if (stateChange = '1') then
                    if (BTNC = '0') then
                        stateChange <= '0';  -- Reset stateChange flag when button C is not pressed
                    end if;
                elsif (BTNC = '1') then
                    state <= "10";              -- Transition to the next state
                    stateChange <= '1';         -- Set stateChange flag to indicate state transition
                end if;
            else -- Display answer
                if (stateChange = '1') then
                    if (BTNU or BTND or BTNL or BTNR or BTNC) = '0' then
                        stateChange <= '0';  -- Reset stateChange flag when buttons are not pressed
                    end if;
                elsif (BTNU or BTND or BTNL or BTNR or BTNC) = '1' then
                    state <= "00";              -- Transition to the initial state
                    stateChange <= '1';         -- Set stateChange flag to indicate state transition
                end if;
            end if;
        end if;
        StateOut <= state;          -- Output the current state
        Operator <= operate;        -- Output the current operator
    end process;
end Behavioral;