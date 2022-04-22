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

COMPONENT Instruction_Memory_File
PORT(
Addr : in STD_LOGIC_VECTOR (7 downto 0);
CLK : in STD_LOGIC;
O : out STD_LOGIC_VECTOR (31 downto 0)
);
END COMPONENT;
--Instruction_Memory_File
--Inputs
signal IMF_Addr: std_logic_vector(7 downto 0) := (others => '0');
signal IMF_CLK: std_logic;
--Outputs
signal IMF_O: std_logic_vector(31 downto 0) := (others => '0');

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
signal RF_W : STD_LOGIC;
signal RF_DATA : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal RF_RST : STD_LOGIC;--actif bas
signal RF_CLK : STD_LOGIC;
--Outputs
signal RF_QA : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal RF_QB : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

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

COMPONENT Data_Memory_File
PORT(
Addr : in STD_LOGIC_VECTOR (7 downto 0);
I : in STD_LOGIC_VECTOR (7 downto 0);
RW : in STD_LOGIC;
RST : in STD_LOGIC;
CLK : in STD_LOGIC;
O : out STD_LOGIC_VECTOR (7 downto 0)
);
END COMPONENT;
--DMF
--Inputs
signal DMF_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');
signal DMF_I : STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');
signal DMF_RW : STD_LOGIC;
signal DMF_RST : STD_LOGIC;
signal DMF_CLK : STD_LOGIC;
--Outputs
signal DMF_O : STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');

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
CLK : in STD_LOGIC
);
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

--IMF
IMF : Instruction_Memory_File PORT MAP(
Addr => IMF_Addr,
CLK => IMF_CLK,
O => IMF_O
);

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

--UAL
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

--DIEX
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

--Exmem
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

--MemRE
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
