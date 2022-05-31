----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.05.2022 15:48:43
-- Design Name: 
-- Module Name: Test_Control_Unit - Behavioral
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

entity Test_Control_Unit is
--  Port ( );
end Test_Control_Unit;

architecture Behavioral of Test_Control_Unit is
COMPONENT Control_Unit
PORT ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           OPin : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC_VECTOR (7 downto 0);
           Aout : out STD_LOGIC_VECTOR (7 downto 0);
           Bouftou : out STD_LOGIC_VECTOR (7 downto 0);     
           Cout : out STD_LOGIC_VECTOR (7 downto 0);
           OPout : out STD_LOGIC_VECTOR (7 downto 0);
           Blok : out STD_LOGIC;
           CLK : in STD_LOGIC
       );
END COMPONENT;
--Control_Unit
--Inputs
signal CU_Ain : STD_LOGIC_VECTOR (7 downto 0);
signal CU_OPin : STD_LOGIC_VECTOR (7 downto 0);
signal CU_Bin : STD_LOGIC_VECTOR (7 downto 0);
signal CU_Cin : STD_LOGIC_VECTOR (7 downto 0);
signal CU_CLK : STD_LOGIC := '0';
--Outputs
signal CU_Aout : STD_LOGIC_VECTOR (7 downto 0);
signal CU_Bouftou : STD_LOGIC_VECTOR (7 downto 0);
signal CU_Cout : STD_LOGIC_VECTOR (7 downto 0);
signal CU_OPout : STD_LOGIC_VECTOR (7 downto 0);
signal CU_Blok : STD_LOGIC;
constant Clock_period : time := 2 ns;

begin
CU : Control_Unit PORT MAP(
Ain=>CU_Ain,
OPin=>CU_OPin,
Bin=>CU_Bin,
Cin=>CU_Cin,
CLK=>CU_CLK,
Aout=>CU_Aout,
Bouftou=>CU_Bouftou,
Cout=>CU_Cout,
OPout=>CU_OPout,
Blok=>CU_Blok
);

Clock_process : process
begin
CU_CLK <= not(CU_CLK);
wait for Clock_period/2;
end process;

CU_Ain<= X"01" after 2 ns, X"02" after 4 ns, X"03" after 6 ns;
CU_Bin<= X"02" after 2 ns, X"05" after 4 ns, X"06" after 6 ns;
CU_Cin<= X"03" after 2 ns, X"04" after 4 ns, X"05" after 6 ns;
CU_OPin<= X"01" after 2 ns, X"02" after 4 ns, X"03" after 6 ns;
end Behavioral;
