----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2022 11:01:10
-- Design Name: 
-- Module Name: Processor - Behavioral
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

entity Processor is       
end Processor;

architecture Behavioral of Processor is


COMPONENT UAL
PORT(
A : in STD_LOGIC_VECTOR (7 downto 0);
B : in STD_LOGIC_VECTOR (7 downto 0);
Ctrl_Alu : in STD_LOGIC_VECTOR (2 downto 0);
S : out STD_LOGIC_VECTOR (7 downto 0);
N : out STD_LOGIC;
O : out STD_LOGIC;
Z : out STD_LOGIC;
C : out STD_LOGIC);
END COMPONENT;
--UAL
--Inputs
signal A_UAL: std_logic_vector(7 downto 0) := (others => '0');
signal B_UAL: std_logic_vector(7 downto 0) := (others => '0');
signal Ctrl_Alu_UAL : STD_LOGIC_VECTOR (2 downto 0) := (others =>'0');
--Outputs
signal S_UAL : STD_LOGIC_VECTOR (7 downto 0);
signal N_UAL : STD_LOGIC;
signal O_UAL : STD_LOGIC;
signal Z_UAL : STD_LOGIC;
signal C_UAL : STD_LOGIC;

COMPONENT Pipeline
PORT(
Ain : in STD_LOGIC_VECTOR (7 downto 0);
Bin : in STD_LOGIC_VECTOR (7 downto 0);
Cin : in STD_LOGIC_VECTOR (7 downto 0);
OPin : in STD_LOGIC_VECTOR (3 downto 0);
Aout : out STD_LOGIC_VECTOR (7 downto 0);
Bouftou : out STD_LOGIC_VECTOR (7 downto 0);     
Cout : out STD_LOGIC_VECTOR (7 downto 0);
OPout : out STD_LOGIC_VECTOR (3 downto 0);
CLK : in STD_LOGIC);
END COMPONENT;

--LIDI
--Inputs
signal Ain_LIDI: std_logic_vector(7 downto 0) := (others=> '0');
signal Bin_LIDI: std_logic_vector(7 downto 0) := (others=> '0');
signal Cin_LIDI: std_logic_vector(7 downto 0) := (others=> '0');
signal OPin_LIDI: std_logic_vector(3 downto 0) := (others=> '0');
signal CLK_LIDI: std_logic := '0';
--Outputs
signal Aout_LIDI : std_logic_vector(7 downto 0) := (others=> '0');
signal Bouftou_LIDI : std_logic_vector(7 downto 0) := (others=> '0');
signal Cout_LIDI : std_logic_vector(7 downto 0) := (others=> '0');
signal OPout_LIDI : std_logic_vector(3 downto 0) := (others=> '0');

--DIEX
--Inputs
signal Ain_DIEX: std_logic_vector(7 downto 0) := (others=> '0');
signal Bin_DIEX: std_logic_vector(7 downto 0) := (others=> '0');
signal Cin_DIEX: std_logic_vector(7 downto 0) := (others=> '0');
signal OPin_DIEX: std_logic_vector(3 downto 0) := (others=> '0');
signal CLK_DIEX: std_logic := '0';
--Outputs
signal Aout_DIEX : std_logic_vector(7 downto 0) := (others=> '0');
signal Bouftou_DIEX : std_logic_vector(7 downto 0) := (others=> '0');
signal Cout_DIEX : std_logic_vector(7 downto 0) := (others=> '0');
signal OPout_DIEX : std_logic_vector(3 downto 0) := (others=> '0');

--EXmem
--Inputs
signal Ain_Exmem: std_logic_vector(7 downto 0) := (others=> '0');
signal Bin_Exmem: std_logic_vector(7 downto 0) := (others=> '0');
signal Cin_Exmem: std_logic_vector(7 downto 0) := (others=> '0');
signal OPin_Exmem: std_logic_vector(3 downto 0) := (others=> '0');
signal CLK_Exmem: std_logic := '0';
--Outputs
signal Aout_Exmem : std_logic_vector(7 downto 0) := (others=> '0');
signal Bouftou_Exmem : std_logic_vector(7 downto 0) := (others=> '0');
signal Cout_Exmem : std_logic_vector(7 downto 0) := (others=> '0');
signal OPout_Exmem : std_logic_vector(3 downto 0) := (others=> '0');

--MemRE
--Inputs
signal Ain_MemRE: std_logic_vector(7 downto 0) := (others=> '0');
signal Bin_MemRE: std_logic_vector(7 downto 0) := (others=> '0');
signal Cin_MemRE: std_logic_vector(7 downto 0) := (others=> '0');
signal OPin_MemRE: std_logic_vector(3 downto 0) := (others=> '0');
signal CLK_MemRE: std_logic := '0';
--Outputs
signal Aout_MemRE : std_logic_vector(7 downto 0) := (others=> '0');
signal Bouftou_MemRE : std_logic_vector(7 downto 0) := (others=> '0');
signal Cout_MemRE : std_logic_vector(7 downto 0) := (others=> '0');
signal OPout_MemRE : std_logic_vector(3 downto 0) := (others=> '0');

begin
--UAL
C_UAL : UAL PORT MAP(
A=> A_UAL,
B=> B_UAL,
Ctrl_Alu=> Ctrl_Alu_UAL,
S=> S_UAL,
N=> N_UAL
O=> O_UAL,
Z=> Z_UAL,
C=> C_UAL
);
--LIDI
Pipeline_LIDI: Pipeline PORT MAP(
Ain=>Ain_LIDI,
Bin=>Bin_LIDI,
Cin=>Cin_LIDI,
OPin=>OPin_LIDI,
Aout=>Aout_LIDI,
Bouftou=>Bouftou_LIDI,
Cout=>Cout_LIDI,
OPout=>OPout_LIDI,
CLK=>CLK_LIDI
);

Pipeline_DIEX: Pipeline PORT MAP(
Ain=>Ain_DIEX,
Bin=>Bin_DIEX,
Cin=>Cin_DIEX,
OPin=>OPin_DIEX,
Aout=>Aout_DIEX,
Bouftou=>Bouftou_DIEX,
Cout=>Cout_DIEX,
OPout=>OPout_DIEX,
CLK=>CLK_DIEX
);

Pipeline_Exmem: Pipeline PORT MAP(
Ain=>Ain_Exmem,
Bin=>Bin_Exmem,
Cin=>Cin_Exmem,
OPin=>OPin_Exmem,
Aout=>Aout_Exmem,
Bouftou=>Bouftou_Exmem,
Cout=>Cout_Exmem,
OPout=>OPout_Exmem,
CLK=>CLK_Exmem
);

Pipeline_MemRE: Pipeline PORT MAP(
Ain=>Ain_MemRE,
Bin=>Bin_MemRE,
Cin=>Cin_MemRE,
OPin=>OPin_MemRE,
Aout=>Aout_MemRE,
Bouftou=>Bouftou_MemRE,
Cout=>Cout_MemRE,
OPout=>OPout_MemRE,
CLK=>CLK_MemRE
);
end Behavioral;
