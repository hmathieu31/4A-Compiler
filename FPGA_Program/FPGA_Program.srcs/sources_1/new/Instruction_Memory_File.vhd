----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2022 09:56:21
-- Design Name: 
-- Module Name: Instruction_Memory_File - Behavioral
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

entity Instruction_Memory_File is
    Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (31 downto 0);
           Blok : in STD_LOGIC
           );
end Instruction_Memory_File;

architecture Behavioral of Instruction_Memory_File is

  type Imem is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
  signal Instindex : Imem := (others =>(others =>'0'));


begin
--enter the instructions in the instruction memory : (X"OPAABBCC")
  Instindex(1) <= X"01010203";
  Instindex(2) <= X"02020304"; 
    process
    begin
        wait until CLK'event and CLK='1';
        if Blok ='0' then
            O<=Instindex(to_integer(unsigned(Addr)));
        elsif Blok='1' then
            O<=X"00000000";
        end if;
    end process;


end Behavioral;
