----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2022 10:19:56
-- Design Name: 
-- Module Name: Test_UAL - Behavioral
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

entity Test_UAL is
end Test_UAL;
architecture Behavioral of Test_UAL is

COMPONENT UAL
PORT(
A : in STD_LOGIC_VECTOR (7 downto 0);
B : in STD_LOGIC_VECTOR (7 downto 0);
Ctrl_Alu : in STD_LOGIC_VECTOR (2 downto 0);
S : out STD_LOGIC_VECTOR (7 downto 0);
N : out STD_LOGIC;
O : out STD_LOGIC;
Z : out STD_LOGIC;
C : out STD_LOGIC
);
END COMPONENT;
--UAL
--Inputs
signal UAL_A: std_logic_vector(7 downto 0) := (others => '0');
signal UAL_B: std_logic_vector(7 downto 0) := (others => '0');
signal UAL_Ctrl_Alu : STD_LOGIC_VECTOR (2 downto 0) := (others =>'0');
--Outputs
signal UAL_S : STD_LOGIC_VECTOR (7 downto 0);
signal UAL_N : STD_LOGIC;
signal UAL_O : STD_LOGIC;
signal UAL_Z : STD_LOGIC;
signal UAL_C : STD_LOGIC;

begin

Ual_UAL : UAL PORT MAP(
A=> UAL_A,
B=> UAL_B,
Ctrl_Alu=> UAL_Ctrl_Alu,
S=> UAL_S,
N=> UAL_N,
O=> UAL_O,
Z=> UAL_Z,
C=> UAL_C
);

UAL_A<=X"01" after 200 ns, X"80" after 400 ns, X"1e" after 450 ns;
UAL_B<=X"02" after 200 ns, X"80" after 400 ns, X"0a" after 450 ns;
UAL_Ctrl_Alu<="001" after 250 ns, "010" after 300 ns, "011" after 350 ns, "001" after 400 ns, "010" after 450 ns;
end Behavioral;
