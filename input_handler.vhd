----------------------------------------------------------------------------------
-- Authors: Jack Zarifeh, Mitchell Hollows, Zeb Barry
-- 
-- Create Date: 11.03.2019
-- Module Name: input_handler - Behavioural
-- Project Name: ENEL373 FPGA Project
-- Target Devices: Nexys-4 DDR FPGA
-- Description: Handles the operator inputs.
--              Takes 16-bit input from switches and separates them into 
--              the two A & B operands registers. Moves the operator to the
--		        operator register. Displays the result ALU calculation on
--              the led array
--		
-- Revision 0.01 - File Created
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
    Port ( CLK : in STD_LOGIC;                          -- input clk
           STATE : in STD_LOGIC_VECTOR (1 downto 0);    -- finite state
           INPUT : in STD_LOGIC_VECTOR (15 downto 0);   -- switch inputs
           RESULT : in STD_LOGIC_VECTOR (7 downto 0);   -- resultant vector
           OUTPUT : out STD_LOGIC_VECTOR (15 downto 0); -- led output
           R0 : out STD_LOGIC_VECTOR (7 downto 0);      -- operand A register
           R1 : out STD_LOGIC_VECTOR (7 downto 0);      -- operand B register
           OP : out STD_LOGIC_VECTOR (3 downto 0));     -- operator register
end input_handler;

architecture Behavioral of input_handler is

signal LED_OUT, in_buffer : STD_LOGIC_VECTOR (15 downto 0);

begin

in_buffer <= INPUT;
    
    -- internal signal varibles
    HANDLER : process (STATE, CLK)
    variable operand_1 : STD_LOGIC_VECTOR (7 downto 0);
    variable operand_2 : STD_LOGIC_VECTOR (7 downto 0);
    variable operator : STD_LOGIC_VECTOR (3 downto 0);
    
    begin
    if (CLK'event AND CLK = '1') then               -- rising clock edge event
        if (STATE = "00") then                      -- state = 0
            operand_1 := in_buffer (15 downto 8);   -- separate operand A
            operand_2 := in_buffer (7 downto 0);    -- separate operand B
            LED_OUT (15 downto 8) <= operand_1;
            LED_OUT (7 downto 0) <= operand_2;
        elsif (STATE = "01") then                   -- state = 1
            operator := in_buffer (3 downto 0);
            LED_OUT (15 downto 4) <= "000000000000";
            LED_OUT (3 downto 0) <= operator;
        elsif (STATE = "10") then                   -- state = 2
            LED_OUT (15 downto 8) <= "00000000";
            LED_OUT (7 downto 0) <= RESULT;
        end if;
    end if;
    R0 <= operand_1;                                -- shift to R0 register
    R1 <= operand_2;                                -- shift to R1 register
    OP <= operator;                                 -- shift to OP register
    end process HANDLER;
    
    OUTPUT <= LED_OUT;                              -- Output register to leds

end Behavioral;
