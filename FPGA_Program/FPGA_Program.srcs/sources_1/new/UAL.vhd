----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.04.2022 10:03:34
-- Design Name: 
-- Module Name: UAL - Behavioral
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

entity UAL is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in STD_LOGIC_VECTOR (2 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC);
end UAL;

architecture Behavioral of UAL is
            signal mlda : std_logic_vector(15 downto 0);
            signal A16 : std_logic_vector(15 downto 0); 
            signal B16 : std_logic_vector(15 downto 0);
begin
    A16<=X"00"&A;
    B16<=X"00"&B;
        mlda<=A16+B16 when Ctrl_Alu="001";
            
        mlda<= A*B when Ctrl_Alu="010";
            
        mlda<=A16-B16 when Ctrl_Alu="011";
        --when "100" =>
            --mlda<= A sll B;--vérifier comment sll marche avec des bits fields
     N<='1' when B>A;
     N<='0' when A>B;
     O<='0' when mlda(15 downto 8)=X"00";
     O<='1' when mlda(15 downto 8)/=X"00";
     Z<='1' when mlda=X"0000";
     Z<='0' when mlda/=X"0000";
     C<=mlda(8);    
     S<=mlda(7 downto 0);
end Behavioral;
