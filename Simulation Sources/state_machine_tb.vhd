----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: state_machine_tb - Behavioral
-- Description: This simulation source is a testbench for the state machine module
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;

entity state_machine_tb is
end state_machine_tb;

architecture Behavioral of state_machine_tb is

    component state_machine
    port (
        BTNU, BTND, BTNL, BTNR, BTNC : in STD_LOGIC;
        Operator, StateOut : out std_logic_vector(1 downto 0);
        clock : in std_logic
    );
    end component;
    
    signal BTNU, BTND, BTNL, BTNR, BTNC, clock : STD_LOGIC := '0';
    signal Operator, StateOut : STD_LOGIC_VECTOR (1 downto 0);
    
begin

    UUT: state_machine 
        port map (
            BTNU => BTNU,
            BTND => BTND,
            BTNL => BTNL,
            BTNR => BTNR,
            BTNC => BTNC,
            Operator => Operator,
            StateOut => StateOut,
            clock => clock
        );
             
   clk_process : process
   begin
        clock <= '0';
        wait for 10ns;  -- for 0.5 ns signal is '0'.
        clock <= '1';
        wait for 10ns;  -- for next 0.5 ns signal is '1'.
   end process;

   process
   begin
        BTNU <= '1';         -- Simulate button press for BTNU
        wait for 50ns;
        BTNU <= '0';         -- Simulate button release for BTNU
        wait for 10ns;
        BTNC <= '1';         -- Simulate button press for BTNC
        wait for 50ns;
        BTNC <= '0';         -- Simulate button release for BTNC
        wait for 10ns;
        BTNL <= '1';         -- Simulate button press for BTNL
        wait for 50ns;
        BTNL <= '0';         -- Simulate button release for BTNL
        wait for 10ns;
   end process;
   
end Behavioral;