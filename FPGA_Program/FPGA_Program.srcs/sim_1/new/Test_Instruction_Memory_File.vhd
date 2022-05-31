----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2022 10:52:34
-- Design Name: 
-- Module Name: Test_Instruction_Memory_File - Behavioral
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

entity Test_Instruction_Memory_File is
end Test_Instruction_Memory_File;

architecture Behavioral of Test_Instruction_Memory_File is

COMPONENT Instruction_Memory_File
PORT(
Addr : in STD_LOGIC_VECTOR (7 downto 0);
CLK : in STD_LOGIC;
O : out STD_LOGIC_VECTOR (31 downto 0);
Blok : in STD_LOGIC
);
END COMPONENT;
--Instruction_Memory_File
--Inputs
signal IMF_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal IMF_CLK : STD_LOGIC := '0';
signal IMF_Blok : STD_LOGIC := '0';
--Outputs
signal IMF_O : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');


constant Clock_period : time := 2 ns;
begin
--IMF
IMF : Instruction_Memory_File PORT MAP(
Addr=>IMF_Addr,
CLK=> IMF_CLK,
O=> IMF_O,
Blok=>IMF_Blok
);

Clock_process : process
begin
IMF_CLK <= not(IMF_CLK);
wait for Clock_period/2;
end process;

IMF_Addr <= X"01" after 2 ns, X"02" after 5 ns;
IMF_Blok<= '1' after 4 ns, '0'after 8 ns;
end Behavioral;
