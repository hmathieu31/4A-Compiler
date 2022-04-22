----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2022 11:41:43
-- Design Name: 
-- Module Name: Test_Register_File - Behavioral
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

entity Test_Register_File is
end Test_Register_File;

architecture Behavioral of Test_Register_File is

COMPONENT Register_File
PORT(
addrA : in STD_LOGIC_VECTOR (3 downto 0);
addrB : in STD_LOGIC_VECTOR (3 downto 0);
addrW : in STD_LOGIC_VECTOR (3 downto 0);
W : in STD_LOGIC;
DATA : in STD_LOGIC_VECTOR (7 downto 0);
RST : in STD_LOGIC;--actif bas
CLK : in STD_LOGIC;
QA : out STD_LOGIC_VECTOR (7 downto 0);
QB : out STD_LOGIC_VECTOR (7 downto 0)
);
END COMPONENT;
--Register_File
--Inputs
signal RF_addrA : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal RF_addrB : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal RF_addrW : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal RF_W : STD_LOGIC := '0';
signal RF_DATA : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal RF_RST : STD_LOGIC := '1';--actif bas
signal RF_CLK : STD_LOGIC := '0';
--Outputs
signal RF_QA : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal RF_QB : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

constant Clock_period : time := 2 ns;
begin
--RF
RF : Register_File PORT MAP(
addrA => RF_addrA,
addrB => RF_addrB,
addrW => RF_addrW,
W  => RF_W,
DATA => RF_DATA,
RST => RF_RST,
CLK => RF_CLK,
QA => RF_QA,
QB => RF_QB
);

Clock_process : process
begin
RF_CLK <= not(RF_CLK);
wait for Clock_period/2;
end process;

RF_W<= '1' after 10 ns, '0' after 12 ns, '1' after 20ns,'0' after 22 ns;
RF_DATA<= X"55" after 10 ns, X"32" after 20 ns;
RF_addrW<="0001" after 10ns, "0010" after 20ns;
RF_addrA<="0001" after 14ns;
RF_addrB<="0010" after 14ns;
RF_RST<='0' after 20ns, '1' after 22ns, '0' after 24 ns, '1'after 26ns;
end Behavioral;
