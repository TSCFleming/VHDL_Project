----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: multi_reg - Behavioral
-- Description: This module is a multiplexer that determines which register
-- the state of the switches should be saved to
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi_reg is
    Port (
        SW : in STD_LOGIC_VECTOR (15 downto 0);     -- Input switches
        State : in STD_LOGIC_VECTOR (1 downto 0);    -- State input
        clock : in std_logic;                        -- Clock input
        Num1_reg, Num2_reg : out STD_LOGIC_VECTOR (12 downto 0);   -- Output registers
        Capture_reg1, Capture_reg2: out STD_LOGIC     -- Output capture signals
    );
end multi_reg;

architecture Behavioral of multi_reg is
    signal Num1, Num2 : STD_LOGIC_VECTOR (12 downto 0);  -- Internal signals for register values
    signal reg1, reg2 : STD_LOGIC;                       -- Internal signals for register control

begin
    
    process (clock)
    begin
        if ((clock'Event) and (clock = '1')) then
            reg1 <= '0';             -- Clear reg1 control signal
            reg2 <= '0';             -- Clear reg2 control signal
            Num1 <= ( others => '0'); -- Clear Num1 register value
            Num2 <= ( others => '0'); -- Clear Num2 register value
            
            if (State = "00") then
                Num1(11 downto 0) <= SW(11 downto 0);  -- Save lower 12 bits of SW to Num1
                Num1(12) <= SW(15);                   -- Save bit 15 of SW to the sign bit of Num1
                reg1 <= '1';                           -- Set reg1 control signal to enable storing values in Num1 register
            elsif (State = "01") then
                Num2(11 downto 0) <= SW(11 downto 0);  -- Save lower 12 bits of SW to Num2
                Num2(12) <= SW(15);                   -- Save bit 15 of SW to the sign bit of Num2
                reg2 <= '1';                           -- Set reg2 control signal to enable storing values in Num2 register
            end if;
        end if;
    end process;
    
    Capture_reg1 <= reg1;                   -- Output the value of reg1 as Capture_reg1
    Capture_reg2 <= reg2;                   -- Output the value of reg2 as Capture_reg2
    Num1_reg <= Num1;                       -- Output the value of Num1 as Num1_reg
    Num2_reg <= Num2;                       -- Output the value of Num2 as Num2_reg
    
end Behavioral;