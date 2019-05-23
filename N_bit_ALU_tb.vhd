----------------------------------------------------------------------------------
-- Authors: Jack Zarifeh, Mitchell Hollows, Zeb Barry
-- 
-- Create Date: 8.03.2019 16:51:06
-- Module Name: N_bit_ALU_tb - Behavioral
-- Project Name: ENEL373 FPGA Project
-- Target Devices: Any
-- Description: Testbench for testing N-bit ALU.
-- 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity N_bit_ALU_tb is
--  No inputs or outputs as is a Testbench.
end N_bit_ALU_tb;

architecture Behavioral of N_bit_ALU_tb is

-- Behavioural implementation of N-bit ALU. Takes two input registers
-- and a 4-bit operator code to determine operation - Either AND, OR, + or -.
component N_bit_ALU
    generic ( N : INTEGER := 7);
    
    Port ( A : in STD_LOGIC_VECTOR (N downto 0);
           B : in STD_LOGIC_VECTOR (N downto 0);
           RESULT : out STD_LOGIC_VECTOR (N downto 0);
           op : in STD_LOGIC_VECTOR (3 downto 0);
           EN : in STD_LOGIC);
end component;

signal EN : STD_LOGIC;
signal A : STD_LOGIC_VECTOR (7 downto 0);
signal B : STD_LOGIC_VECTOR (7 downto 0);
signal RESULT : STD_LOGIC_VECTOR (7 downto 0);
signal op : STD_LOGIC_VECTOR (3 downto 0);
constant ClockPeriod : TIME := 50ns;

begin

UUT: N_bit_ALU 
    port map (A => A,
              B => B,
              RESULT => RESULT,
              op => op,
              EN => EN);

EN <= '1';  -- ALU always enabled

process
    begin
        A <= "00011101";
        B <= "10110000";
        op <= "0001";   -- AND
        wait for 100 ns;
        A <= "00110101";
        B <= "10000111";
        op <= "0010";   -- OR
        wait for 100ns;
        A <= "00000011";
        B <= "00001001";
        op <= "0100";   -- Add
        wait for 100ns;
        A <= "00001101";
        B <= "00000010";
        op <= "1000";   -- Subract
        wait;
end process;

end Behavioral;
