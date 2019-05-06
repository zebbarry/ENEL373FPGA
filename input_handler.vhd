----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2019 14:07:08
-- Design Name: 
-- Module Name: input_handler - Behavioral
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

entity input_handler is
    Port ( CLK : in STD_LOGIC;
           STATE : in STD_LOGIC_VECTOR (1 downto 0);
           INPUT : in STD_LOGIC_VECTOR (15 downto 0);
           RESULT : in STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (15 downto 0);
           R0 : out STD_LOGIC_VECTOR (7 downto 0);
           R1 : out STD_LOGIC_VECTOR (7 downto 0);
           OP : out STD_LOGIC_VECTOR (3 downto 0));
end input_handler;

architecture Behavioral of input_handler is

signal LED_OUT, in_buffer : STD_LOGIC_VECTOR (15 downto 0);

begin

in_buffer <= INPUT;
    
    HANDLER : process (STATE, CLK)
    variable operand_1 : STD_LOGIC_VECTOR (7 downto 0);
    variable operand_2 : STD_LOGIC_VECTOR (7 downto 0);
    variable operator : STD_LOGIC_VECTOR (3 downto 0);
    begin
    if (CLK'event AND CLK = '1') then 
        if (STATE = "00") then
            operand_1 := in_buffer (15 downto 8);
            operand_2 := in_buffer (7 downto 0);
            LED_OUT (15 downto 8) <= operand_1;
            LED_OUT (7 downto 0) <= operand_2;
        elsif (STATE = "01") then
            operator := in_buffer (3 downto 0);
            LED_OUT (15 downto 4) <= "000000000000";
            LED_OUT (3 downto 0) <= operator;
        elsif (STATE = "10") then
            LED_OUT (15 downto 8) <= "00000000";
            LED_OUT (7 downto 0) <= RESULT;
        end if;
    end if;
    R0 <= operand_1;
    R1 <= operand_2;
    OP <= operator;
    end process HANDLER;
    
    OUTPUT <= LED_OUT;

end Behavioral;
