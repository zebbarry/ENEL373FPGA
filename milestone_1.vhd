----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2019 16:51:06
-- Design Name: 
-- Module Name: milestone_1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity milestone_1 is
    Port ( BTNC : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           LED16_B, LED16_R, LED17_R, LED17_G : out STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0));
end milestone_1;

architecture Structural of milestone_1 is

component my_divider is
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

component FSM_ALU
    Port ( BUTTON : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : out STD_LOGIC;
           STATE : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component N_bit_ALU
    generic ( N : INTEGER := 7);
    
    Port ( EN : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (N downto 0);
           B : in STD_LOGIC_VECTOR (N downto 0);
           OP : in STD_LOGIC_VECTOR (3 downto 0);
           RESULT : out STD_LOGIC_VECTOR (N downto 0);
           ERROR : out STD_LOGIC);
end component;

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
signal EN, CLK_DIV, BTN_BUF, ERROR : STD_LOGIC;


begin

EN <= STATE (1);
LED16_B <= EN;
LED17_R <= STATE(0);
LED17_G <= NOT STATE(0) AND NOT STATE(1);
LED16_R <= ERROR;

Stage1 : my_divider 
    port map (Clk_in=>CLK100MHZ, 
              Clk_out=>CLK_DIV);
Stage2 : FSM_ALU 
    port map (BUTTON=>BTNC, 
              CLK=>CLK_DIV, 
              STATE=>STATE, 
              BTN=>BTN_BUF);
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
