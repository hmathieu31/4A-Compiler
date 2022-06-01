----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.06.2022 15:11:57
-- Design Name: 
-- Module Name: Instruction_Controller - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Controller is
    Port ( Feedback : in STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC;
           Cublok : in STD_LOGIC; 
           Order : out STD_LOGIC_VECTOR (7 downto 0) := X"00";
           Blok : out STD_LOGIC :='0'
           );
end Instruction_Controller;

architecture Behavioral of Instruction_Controller is
    signal aux_order : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal start_token : STD_LOGIC := '0';
    signal aux_blok : STD_LOGIC;
-- ENTRY (21 X"15")
begin
process
    begin
        wait until CLK'event and CLK='1';
        if start_token='0' and Cublok='0' then
            if Feedback(31 downto 24) /= X"15" or aux_order/=X"FF" then
                aux_order<=std_logic_vector(unsigned(aux_order)+1);
                start_token <='0';
                aux_blok<='1';
            elsif aux_order = X"FF" then
                aux_order<=X"00";
                start_token <='0';
            elsif Feedback(31 downto 24) = X"15" then
                aux_blok<='0';
                start_token<='1';
            end if;
        end if;    
        if start_token ='1' and Cublok='0' then
            aux_blok <= '0';
            aux_order<=std_logic_vector(unsigned(aux_order)+1);
        end if;
Blok<=aux_blok;
Order<=aux_order;
end process;
end Behavioral;
