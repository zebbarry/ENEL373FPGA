----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2019 15:07:33
-- Design Name: 
-- Module Name: N_bit_ALU - Behavioral
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

entity N_bit_ALU is
    generic ( N : INTEGER := 7);
    
    Port ( EN : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (N downto 0);
           B : in STD_LOGIC_VECTOR (N downto 0);
           OP : in STD_LOGIC_VECTOR (3 downto 0);
           RESULT : out STD_LOGIC_VECTOR (N downto 0);
           ERROR : out STD_LOGIC);
end N_bit_ALU;

architecture Behavioral of N_bit_ALU is

begin
    ALU : process (A, B, OP) is 
    begin
        if (EN = '1') then
            case OP is 
                when "0001" => RESULT <= A AND B;
                when "0010" => RESULT <= A OR B;
                when "0100" => RESULT <= A + B;
                when "1000" => RESULT <= A - B;
                when others => ERROR <= '1';
            end case;
        end if;
    end process ALU;
end Behavioral;
