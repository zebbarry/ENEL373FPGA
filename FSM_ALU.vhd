----------------------------------------------------------------------------------
-- Authors: Jack Zarifeh, Mitchell Hollows, Zeb Barry
-- 
-- Create Date: 11.03.2019 16:51:06
-- Module Name: FSM_ALU
-- Project Name: ENEL373 FPGA Project
-- Target Devices: Nexys-4 DDR FPGA
-- Description: Finite state machine to handle the three different states involved in the project,
--              also contains the deboucing process. 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_ALU is
    Port ( BUTTON : in STD_LOGIC;  --Input from the button press (enabler)
           CLK : in STD_LOGIC;  --Clock input (100 MHz)
           STATE : out STD_LOGIC_VECTOR (1 downto 0));  --Outputs the current state
end FSM_ALU;

architecture Behavioral of FSM_ALU is

signal STATE_INT : STD_LOGIC_VECTOR (1 downto 0);  -- internal state signal
signal Q1, Q2, Q3, BTN_BUF : STD_LOGIC;  --Internal signals

begin
DEBOUNCE : process(CLK) IS  --Process triggered when the CLK changes
begin
   if (CLK'event and CLK = '1') then  --When there is a rising clock edge event
     Q1 <= BUTTON;  --Setting internal Q1 to the button input
     Q2 <= Q1;  --Setting Q2 to Q1
     Q3 <= Q2;  --Setting Q3 to Q2
   end if;
end process DEBOUNCE;

BTN_BUF <= Q1 and Q2 and (not Q3);  --Detecting the rising edge
 
FSM : process (BTN_BUF, CLK) is
begin
if (CLK'event and CLK = '1') then  --Rising clock edge event
    if (BTN_BUF = '1') then  --Checking that BTN_BUF is high
        case STATE_INT is
            when "00" => STATE_INT <= "01";  --Setting next state
            when "01" => STATE_INT <= "10";  --Setting next state
            when others => STATE_INT <= "00";  --Setting back to initial state
        end case;
    end if;
end if;
end process FSM;

STATE <= STATE_INT;  --Setting the output state to the internal state found.

end Behavioral;
