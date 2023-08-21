----------------------------------------------------------------------------------
-- Authors: MS, CS, TF.
-- Module Name: calculator_Top - Structural
-- Description: The top level connections between modules.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculator_Top is
  Port ( 
          CLK100MHZ : in std_logic;                        -- 100MHz clock input
          SW : in std_logic_vector(15 downto 0);           -- Switch inputs
          CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC;      -- Seven-segment display outputs
          AN : out std_logic_vector(7 downto 0);           -- Output for seven-segment display
          BTNC, BTNU, BTNL, BTNR, BTND : in std_logic;      -- Button inputs
          LED : out STD_LOGIC_VECTOR (15 downto 0);        -- LED outputs
          LED16_B, LED16_G, LED16_R, LED17_B, LED17_G, LED17_R : out STD_LOGIC -- RGB LED outputs
          );
end calculator_Top;

architecture Structural of calculator_Top is

component multi_reg
    Port ( SW : in STD_LOGIC_VECTOR (15 downto 0);         -- Switch inputs
           State : in STD_LOGIC_VECTOR (1 downto 0);      -- State inputs
           clock : in std_logic;                          -- Clock input
           Num1_reg, Num2_reg : out STD_LOGIC_VECTOR (12 downto 0); -- Register outputs for operands
           Capture_reg1, Capture_reg2 : out STD_LOGIC);   -- Capture signals for registers
end component;

component state_machine
    port( BTNU, BTND, BTNL, BTNR, BTNC : in STD_LOGIC;     -- Button inputs
            Operator, StateOut : out std_logic_vector(1 downto 0); -- Operator and state outputs
            clock : in std_logic);                        -- Clock input
end component;

component registor
    Port ( variable_in : in STD_LOGIC_VECTOR (12 downto 0);  -- Input value to be stored in the register
           capture, clock : in STD_LOGIC;                     -- Capture and clock inputs
           output : out STD_LOGIC_VECTOR (12 downto 0));      -- Stored value output
end component;

component Registor_2bit
    Port ( variable_in : in STD_LOGIC_VECTOR (1 downto 0);   -- Input value to be stored in the register
           capture, clock : in STD_LOGIC;                     -- Capture and clock inputs
           output : out STD_LOGIC_VECTOR (1 downto 0));       -- Stored value output
end component;

component bin_to_bcd
    Port ( DisplayNum : in STD_LOGIC_VECTOR (11 downto 0);  -- Input value to be converted to BCD
            clk : in std_logic;                             -- Clock input
           num1, num2, num3, num4 : out STD_LOGIC_VECTOR (3 downto 0); -- BCD digit outputs
           state : in STD_LOGIC_VECTOR (1 downto 0));       -- State input for BCD conversion
end component;

component multi_seg
    Port ( dig1, dig2, dig3, dig4, dig5, dig6, dig7 :  in STD_LOGIC_VECTOR (3 downto 0); -- BCD digit inputs
           clk, digSign, overflow_ERROR : in STD_LOGIC;     -- Clock input, digit sign input, overflow error input
           bcd : out STD_LOGIC_VECTOR (4 downto 0);        -- BCD value output
           disp : out STD_LOGIC_VECTOR (7 downto 0));      -- Seven-segment display outputs
end component;

component ALU
    Port ( NUM1 : in STD_LOGIC_VECTOR (12 downto 0);      -- Operand 1 input
           NUM2 : in STD_LOGIC_VECTOR (12 downto 0);      -- Operand 2 input
           Operator, state : in STD_LOGIC_VECTOR (1 downto 0); -- Operator and state inputs
           Overflow : out std_logic;                      -- Overflow flag output
           Result : out STD_LOGIC_VECTOR (12 downto 0));  -- Result output
end component;

component disp_clk_divider
    Port ( clk : in STD_LOGIC;                            -- Input clock
           div_clk : out STD_LOGIC);                      -- Divided clock output
end component;

component BCD_to_7SEG
    Port ( bcd_in: in std_logic_vector (4 downto 0);      -- BCD input
           leds_out: out	std_logic_vector (1 to 7));     -- Seven-segment LED outputs
end component;

component multi_Disp
    Port ( SW : in STD_LOGIC_VECTOR (15 downto 0);        -- Switch inputs
           Answer : in STD_LOGIC_VECTOR (12 downto 0);    -- Answer input
           numOut : out STD_LOGIC_VECTOR (11 downto 0);   -- Numerical output
           sign : out STD_LOGIC;                          -- Sign output
           State : in STD_LOGIC_VECTOR (1 downto 0));     -- State input
end component;

component Debouncer
    Port ( BTNC, BTNU, BTND, BTNL, BTNR: in STD_LOGIC;     -- Button inputs
           CLK_100MHZ : in STD_LOGIC;                     -- 100MHz clock input
           BTNC_D, BTNU_D, BTND_D, BTNL_D, BTNR_D : out STD_LOGIC);  -- Debounced button outputs
end component;

component led_display
    Port ( Reg1 : in STD_LOGIC_VECTOR (12 downto 0);      -- Operand 1 input
           Reg2 : in STD_LOGIC_VECTOR (12 downto 0);      -- Operand 2 input
           State : in STD_LOGIC_VECTOR (1 downto 0);      -- State input
           Opcode : in STD_LOGIC_VECTOR (1 downto 0);     -- Operator input
           LED_array : out STD_LOGIC_VECTOR (15 downto 0); -- LED outputs
           LED16_B, LED16_G, LED16_R, LED17_B, LED17_G, LED17_R : out STD_LOGIC); -- RGB LED outputs
end component;

-- State Machine Outputs
signal Operator, StateOut : STD_LOGIC_VECTOR (1 downto 0);   -- Operator and state outputs
-- Multi Registor Outputs
signal Num1_reg, Num2_reg : STD_LOGIC_VECTOR (12 downto 0);  -- Operand register outputs
signal Capture_reg1, Capture_reg2 : std_logic;                -- Capture signals for registers
-- Num1 Register Outputs
signal Num1_regOut : STD_LOGIC_VECTOR (12 downto 0);          -- Output from the Num1 register
-- Num2 Register Outputs
signal Num2_regOut : STD_LOGIC_VECTOR (12 downto 0);          -- Output from the Num2 register
-- Register Outputs
signal Op_regOut : STD_LOGIC_VECTOR (1 downto 0);             -- Output from the Op register
-- ALU Outputs
signal ResultOut : STD_LOGIC_VECTOR (12 downto 0);             -- Output from the ALU
signal overflow_ERROR : STD_LOGIC;                             -- Overflow flag
-- Multi Disp Outputs
signal numOut : STD_LOGIC_VECTOR (11 downto 0);                -- Numerical output
signal signOut : std_logic;                                    -- Sign output
-- Clk Divider Outputs
signal disp_div_clk : std_logic;                               -- Divided clock output
-- 7-Segment Display Digits
signal dig1_bcd, dig2_bcd, dig3_bcd, dig4_bcd, dig5_bcd, dig6_bcd, dig7_bcd: std_logic_vector (3 downto 0); -- BCD digit inputs
signal bcd_out : std_logic_vector (4 downto 0);                -- BCD output
-- Button Debouncer Outputs
signal BTNC_D, BTNU_D, BTNL_D, BTNR_D, BTND_D : std_logic;      -- Debounced button outputs
signal BTN_Blank : std_logic;                                  -- Blank button signal
-- LED Display Outputs
signal LEDs : STD_LOGIC_VECTOR (15 downto 0);                  -- LED outputs

begin
    U13 : Debouncer
        Port map( BTNC => BTNC, BTNU => BTNU, BTND => BTND, BTNL => BTNL, BTNR => BTNR,
               CLK_100MHZ => CLK100MHZ,
               BTNC_D => BTNC_D, BTNU_D => BTNU_D, BTND_D => BTND_D, BTNL_D => BTNL_D, BTNR_D => BTNR_D );
    U1 : state_machine
        port map (BTNU => BTNU_D, BTND => BTND_D, BTNL => BTNL_D, BTNR => BTNR_D, BTNC => BTNC_D,
                Operator => Operator(1 downto 0), StateOut => StateOut(1 downto 0),
                clock => CLK100MHZ);
    U2 : multi_reg
        Port map ( SW => SW(15 downto 0),
               State => StateOut(1 downto 0),
               clock => CLK100MHZ, 
               Num1_reg => Num1_reg(12 downto 0), Num2_reg => Num2_reg(12 downto 0),
               Capture_reg1 => Capture_reg1, Capture_reg2 => Capture_reg2);
    U3 : registor
        Port map ( variable_in => Num1_reg(12 downto 0),
               capture => Capture_reg1,
               clock => CLK100MHZ,
               output => Num1_regOut(12 downto 0));
    U4 : registor
        Port map ( variable_in => Num2_reg(12 downto 0),
               capture => Capture_reg2,
               clock => CLK100MHZ,
               output => Num2_regOut(12 downto 0));
    U5 : Registor_2bit
        Port map ( variable_in => Operator(1 downto 0),
               capture => Capture_reg1,
               clock => CLK100MHZ,
               output(1 downto 0) => Op_regOut(1 downto 0));
    U6 : ALU
        Port map ( NUM1 => Num1_regOut(12 downto 0),
               NUM2 => Num2_regOut(12 downto 0),
               Operator => Operator(1 downto 0),
               state => StateOut,
               Result => ResultOut(12 downto 0),
               Overflow => overflow_ERROR);
    U7 : multi_Disp
        Port map ( SW => SW(15 downto 0),
               Answer => ResultOut(12 downto 0),
               State => StateOut(1 downto 0),
               numOut => numOut(11 downto 0),
               sign => signOut);
    U8 : disp_clk_divider
        Port map (
                div_clk => disp_div_clk, clk => CLK100MHZ);
    U9 : bin_to_bcd
        Port map( DisplayNum => numOut(11 downto 0),
               clk => CLK100MHZ,
               state => StateOut(1 downto 0),
               num1 => dig1_bcd,
               num2 => dig2_bcd,
               num3 => dig3_bcd,
               num4 => dig4_bcd);
    U10 : multi_seg
        Port map ( 
               dig1 => dig1_bcd(3 downto 0),
               dig2 => dig2_bcd(3 downto 0),
               dig3 => dig3_bcd(3 downto 0),
               dig4 => dig4_bcd(3 downto 0),
               dig5 => "1111",
               dig6 => "1111",
               dig7 => "1111",
               digSign => signOut,
               overflow_ERROR => overflow_ERROR,
               clk => disp_div_clk, bcd => bcd_out(4 downto 0),
               disp =>AN(7 downto 0));
    U11 : BCD_to_7SEG
        Port map ( bcd_in => bcd_out(4 downto 0),
               leds_out(1) => CA,
               leds_out(2) => CB,
               leds_out(3) => CC,  
               leds_out(4) => CD,  
               leds_out(5) => CE,  
               leds_out(6) => CF,  
               leds_out(7) => CG);
    U12 : led_display
        Port map (State => StateOut,
                Reg1 => Num1_regOut,
                Reg2 => num2_regOut,
                Opcode => Operator,
                LED_array => LED,
                LED16_B => LED16_B, LED16_G => LED16_G, LED16_R => LED16_R,
                LED17_B => LED17_B, LED17_G => LED17_G, LED17_R => LED17_R);

end Structural;
