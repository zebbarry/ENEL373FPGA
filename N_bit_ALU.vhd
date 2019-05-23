----------------------------------------------------------------------------------
-- Authors: Jack Zarifeh, Mitchell Hollows, Zeb Barry
-- 
-- Create Date: 8.03.2019 16:51:06
-- Module Name: N_bit_ALU - Behavioural
-- Project Name: ENEL373 FPGA Project
-- Target Devices: Any
-- Description: Behavioural implementation of N-bit ALU. Takes two input registers
--              and a 4-bit operator code to determine operation - Either AND, OR, + or -.
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity N_bit_ALU is
    generic ( N : INTEGER := 7);
    
    Port ( EN : in STD_LOGIC;   -- Enable trigger to set result
           A : in STD_LOGIC_VECTOR (N downto 0);    -- Operands
           B : in STD_LOGIC_VECTOR (N downto 0);
           OP : in STD_LOGIC_VECTOR (3 downto 0);   -- Operator code
           RESULT : out STD_LOGIC_VECTOR (N downto 0);
           ERROR : out STD_LOGIC);  -- Error flag set when invalid operator code is used.
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
                when others => ERROR <= '1';    -- Invalid operator code.
            end case;
        end if;
    end process ALU;
end Behavioral;
