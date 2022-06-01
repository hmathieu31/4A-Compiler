----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.06.2022 16:23:10
-- Design Name: 
-- Module Name: Test_Instruction_Controller - Behavioral
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

entity Test_Instruction_Controller is
end Test_Instruction_Controller;

architecture Behavioral of Test_Instruction_Controller is

COMPONENT Instruction_Controller
PORT ( Feedback : in STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC;
           Cublok : in STD_LOGIC; 
           Order : out STD_LOGIC_VECTOR (7 downto 0) := X"00";
           Blok : out STD_LOGIC :='1'
           );
END COMPONENT;
--Instruction_Controller
--Inputs
signal IC_Feedback : STD_LOGIC_VECTOR (31 downto 0);
signal IC_CLK : STD_LOGIC := '0';
signal IC_Cublok : STD_LOGIC:='0';
--Outputs
signal IC_Order : STD_LOGIC_VECTOR (7 downto 0) := X"00";
signal IC_Blok : STD_LOGIC :='1';

constant Clock_period : time := 2 ns;
begin
--IC
IC : Instruction_Controller PORT MAP(
    Feedback=>IC_Feedback,
    CLK=>IC_CLK,
    Cublok=>IC_Cublok,
    Order=>IC_Order,
    Blok=>IC_Blok
);

Clock_process : process
begin
IC_CLK <= not(IC_CLK);
wait for Clock_period/2;
end process;

IC_Feedback<= X"12000000" after 0 ns, X"15000000" after 10 ns, X"12000000" after 12 ns;
IC_Cublok<='0' after 0 ns, '1' after 12ns, '0' after 20 ns;
end Behavioral;
