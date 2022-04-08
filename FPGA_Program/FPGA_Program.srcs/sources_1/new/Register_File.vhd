----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.04.2022 11:25:37
-- Design Name: 
-- Module Name: Register_File - Behavioral
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
use IEEE.Numeric_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity Register_File is
 
    Port ( addrA : in STD_LOGIC_VECTOR (3 downto 0);
           addrB : in STD_LOGIC_VECTOR (3 downto 0);
           addrW : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;--actif bas
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
         
end Register_File;

architecture Behavioral of Register_File is

  type Fischl is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
  signal poiss : Fischl;
  
begin
    process
    begin
        wait until CLK'event and CLK='1';
        if RST='0' then
           poiss<= (others => X"00");
        elsif W='1' then
           poiss(to_integer(unsigned(addrW)))<=DATA;
         end if ;   
    end process;
    QA<=poiss(to_integer(unsigned(addrA)));
    QB<=poiss(to_integer(unsigned(addrB)));
end Behavioral;

