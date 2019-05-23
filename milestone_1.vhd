----------------------------------------------------------------------------------
-- Authors: Jack Zarifeh, Mitchell Hollows, Zeb Barry
-- 
-- Create Date: 11.03.2019 16:51:06
-- Module Name: milestone_1 - Structural
-- Project Name: ENEL373 FPGA Project
-- Target Devices: Nexys-4 DDR FPGA
-- Tool Versions: 
-- Description: Structural implementation of 8-bit ALU. Uses 16 switches to set
--              two nput registers and 4-bit operator code, displaying result using LED's
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity milestone_1 is
    Port ( BTNC : in STD_LOGIC; -- Centre button used for state trigger
           CLK100MHZ : in STD_LOGIC;
           LED16_B, LED16_R, LED17_R, LED17_G : out STD_LOGIC;  -- RGB Leds used to display state.
           SW : in STD_LOGIC_VECTOR (15 downto 0);  -- Input switches used to set registers
           LED : out STD_LOGIC_VECTOR (15 downto 0));   -- Output LED's used to display contents of registers
end milestone_1;

architecture Structural of milestone_1 is

-- Clock divider that reduces 100MHz input to a 50Hz output
component my_divider is
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

-- FSM that outputs a 2-bit state code for three distinct states.
-- State change occurs on rising edge of BUTTON and CLK.
component FSM_ALU
    Port ( BUTTON : in STD_LOGIC;
           CLK : in STD_LOGIC;
           STATE : out STD_LOGIC_VECTOR (1 downto 0));
end component;

-- N-bit ALU with a 4-bit operator code for AND, OR, + and -
-- Only sets result when EN is high. If invalid operator code is used
-- ERROR is set to high.
component N_bit_ALU
    generic ( N : INTEGER := 7);
    
    Port ( EN : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (N downto 0);
           B : in STD_LOGIC_VECTOR (N downto 0);
           OP : in STD_LOGIC_VECTOR (3 downto 0);
           RESULT : out STD_LOGIC_VECTOR (N downto 0);
           ERROR : out STD_LOGIC);
end component;

-- Input handler that uses STATE to set operator and operand registers
-- From operator, operand and result registers, setis LED's to display contents
component input_handler
    Port ( CLK : in STD_LOGIC;
           STATE : in STD_LOGIC_VECTOR (1 downto 0);
           INPUT : in STD_LOGIC_VECTOR (15 downto 0);
           RESULT : in STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (15 downto 0);
           R0 : out STD_LOGIC_VECTOR (7 downto 0);
           R1 : out STD_LOGIC_VECTOR (7 downto 0);
           OP : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal STATE : STD_LOGIC_VECTOR (1 downto 0);
signal RESULT : STD_LOGIC_VECTOR (7 downto 0);
signal operator_1 : STD_LOGIC_VECTOR (7 downto 0);
signal operator_2 : STD_LOGIC_VECTOR (7 downto 0);
signal OP : STD_LOGIC_VECTOR (3 downto 0);
signal EN, CLK_DIV, ERROR : STD_LOGIC;


begin

EN <= STATE (1);
LED16_B <= EN;  -- Calculation state
LED17_R <= STATE(0);    -- Set operator state
LED17_G <= NOT STATE(0) AND NOT STATE(1);   -- Set operands state
LED16_R <= ERROR;   -- Invalid operator code alert

Stage1 : my_divider 
    port map (Clk_in=>CLK100MHZ, 
              Clk_out=>CLK_DIV);
              
Stage2 : FSM_ALU 
    port map (BUTTON=>BTNC, 
              CLK=>CLK_DIV, 
              STATE=>STATE);
              
Stage3 : input_handler 
    port map (CLK=>CLK100MHZ,
              STATE=>STATE,
              INPUT=>SW, 
              RESULT=>RESULT, 
              OUTPUT=>LED, 
              R0=>operator_1, 
              R1=>operator_2, 
              OP=>OP);
              
Stage4 : N_bit_ALU 
    port map (EN=>EN, 
              A=>operator_1,
              B=>operator_2,
              OP=>OP,
              RESULT=>RESULT,
              ERROR=>ERROR);


end Structural;
