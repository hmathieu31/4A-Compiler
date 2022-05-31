----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.05.2022 14:34:58
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control_Unit is
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           OPin : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC_VECTOR (7 downto 0);
           Aout : out STD_LOGIC_VECTOR (7 downto 0);
           Bouftou : out STD_LOGIC_VECTOR (7 downto 0);     
           Cout : out STD_LOGIC_VECTOR (7 downto 0);
           OPout : out STD_LOGIC_VECTOR (7 downto 0);
           Blok : out STD_LOGIC := '0';
           CLK : in STD_LOGIC
           );
end Control_Unit;

architecture Behavioral of Control_Unit is
    signal counter : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal aux_blok : STD_LOGIC :='0';
    signal aux_opout : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    process
    begin
        wait until CLK'event and CLK='1';
        if (OPin = X"01" or OPin = X"02" or OPin = X"03" or OPin = X"05" or OPin = X"06" or OPin = X"14") and counter="000" then
            aux_opout <=OPin;
            counter <="100";
            aux_blok <='1';
        elsif OPin =X"13" and counter="000" then
            aux_opout <=OPin;
            aux_blok<='0';
        elsif counter="100" then
            counter <= "011";
            aux_opout<=X"00";
            aux_blok<='1';
        elsif counter="011" then
            counter <= "010";
            aux_opout<=X"00";
            aux_blok<='1';
        elsif counter="010" then
            counter <= "001";
            aux_opout<=X"00";
            aux_blok<='1';
        elsif counter="001" then
            counter<="000";
            aux_opout<=X"00";
            aux_blok<='0';   
        end if;

    end process;
    Aout<=Ain;
    Bouftou<=Bin;
    Cout<=Cin;
    Blok<=aux_blok;
    OPout<=aux_opout;
end Behavioral;
