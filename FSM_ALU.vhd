----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2019 16:09:47
-- Design Name: 
-- Module Name: FSM_ALU - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_ALU is
    Port ( BUTTON : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : out STD_LOGIC;
           STATE : out STD_LOGIC_VECTOR (1 downto 0));
end FSM_ALU;

architecture Behavioral of FSM_ALU is

signal STATE_INT : STD_LOGIC_VECTOR (1 downto 0);
signal Q1, Q2, Q3, BTN_BUF : STD_LOGIC;

begin
DEBOUNCE : process(CLK) IS
begin
   if (CLK'event and CLK = '1') then
     Q1 <= BUTTON;
     Q2 <= Q1;
     Q3 <= Q2;
   end if;
end process DEBOUNCE;

BTN_BUF <= Q1 and Q2 and (not Q3);
 
FSM : process (BTN_BUF, CLK) is
begin
if (CLK'event and CLK = '1') then
    if (BTN_BUF = '1') then
        case STATE_INT is
            when "00" => STATE_INT <= "01";
            when "01" => STATE_INT <= "10";
            when others => STATE_INT <= "00";
        end case;
    end if;
end if;
end process FSM;

STATE <= STATE_INT;
BTN <= BTN_BUF;

end Behavioral;
