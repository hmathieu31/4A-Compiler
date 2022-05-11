----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2022 12:09:12
-- Design Name: 
-- Module Name: Test_Data_Memory_File - Behavioral
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

entity Test_Data_Memory_File is
--  Port ( );
end Test_Data_Memory_File;

architecture Behavioral of Test_Data_Memory_File is
COMPONENT Data_Memory_File
PORT(
Addr : in STD_LOGIC_VECTOR (7 downto 0);
I : in STD_LOGIC_VECTOR (7 downto 0);
RW : in STD_LOGIC;
RST : in STD_LOGIC;
CLK : in STD_LOGIC;
O : out STD_LOGIC_VECTOR (7 downto 0)
);
END COMPONENT;
--Data_Memory_File
--Inputs
signal DMF_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal DMF_I : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal DMF_RW : STD_LOGIC := '1';
signal DMF_RST : STD_LOGIC := '1';
signal DMF_CLK : STD_LOGIC := '0';
--Outputs
signal DMF_O : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

constant Clock_period : time := 2 ns;
begin
--DMF
DMF : Data_Memory_File PORT MAP(
Addr => DMF_Addr,
I => DMF_I,
RW => DMF_RW,
RST => DMF_RST,
CLK => DMF_CLK,
O=> DMF_O
);

Clock_process : process
begin
DMF_CLK <= not(DMF_CLK);
wait for Clock_period/2;
end process;

DMF_RW <= '0' after 12 ns, '1' after 14 ns, '0' after 18 ns, '1' after 20 ns;
DMF_I <= X"4F" after 10ns, X"44" after 16 ns;
DMF_Addr <= X"01" after 4 ns, X"02" after 16 ns;
DMF_RST <= '0' after 30 ns, '1' after 32ns;
end Behavioral;
