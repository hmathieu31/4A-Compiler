----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2022 09:54:23
-- Design Name: 
-- Module Name: Data_Memory_File - Behavioral
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

entity Data_Memory_File is
    Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0);
           I : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (7 downto 0));
end Data_Memory_File;

architecture Behavioral of Data_Memory_File is
    type Dmem is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
    signal Dataindex : Dmem := (others => (others => '0'));
    
begin
    process
    begin
        wait until CLK'event and CLK='1';
          if RST='0' then
                   Dataindex<= (others => X"00");
          elsif RW='0' then --écriture
            Dataindex(to_integer(unsigned(Addr)))<=I;
          elsif RW='1' then --lecture
            O<=Dataindex(to_integer(unsigned(Addr)));    
          end if;
    end process;
    
end Behavioral;
