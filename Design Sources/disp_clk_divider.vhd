----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: disp_clk_divider - Behavioral
-- Description: This module divides the clock to 1 kHz, which is the rate at which
-- each display needs to be updated to get a non-flickering display output.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;

entity disp_clk_divider is
    Port (
        clk : in STD_LOGIC;       -- Input clock signal
        div_clk : out STD_LOGIC  -- Divided clock signal
    );
end disp_clk_divider;

architecture Behavioral of disp_clk_divider is
    signal q : std_logic_vector(15 downto 0);                -- Counter for dividing the clock
    constant clk_limit : std_logic_vector(15 downto 0) := X"C350"; -- Constant value for comparison (1 kHz)
    signal clk_temp : std_logic;                             -- Temporary clock signal for output
    
begin
    clock: process(clk)
    begin
        if clk'event and clk = '1' then    -- Detect rising edge of the input clock
            if q = clk_limit then
                clk_temp <= not clk_temp;   -- Invert the temporary clock signal
                q <= X"0000";               -- Reset the counter
            else
                q <= q + X"0001";           -- Increment the counter
            end if;
        end if;
    end process clock;
    
    div_clk <= clk_temp;  -- Output the divided clock signal

end Behavioral;