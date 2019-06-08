----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:05:21 06/07/2019 
-- Design Name: 
-- Module Name:    videoMux - vM 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity videoMux is
    Port ( mode : in STD_LOGIC_VECTOR (3 downto 0);
			  RGB : in  STD_LOGIC_VECTOR (23 downto 0);
           HSV : in  STD_LOGIC_VECTOR (23 downto 0);
           Gray : in  STD_LOGIC_VECTOR (7 downto 0);
           C1R : out  STD_LOGIC_VECTOR (7 downto 0);
           C2G : out  STD_LOGIC_VECTOR (7 downto 0);
           C3B : out  STD_LOGIC_VECTOR (7 downto 0));
end videoMux;

architecture vM of videoMux is

begin


videoSelector: process(mode)

begin
case (mode) is
	when "0000" => -- normal RGB output
		C1R <= RGB(23 downto 16);
		C2G <= RGB(15 downto 8);
		C3B <= RGB( 7 downto  0);
	when "0001" => -- Only R
		C1R <= RGB(23 downto 16);
		C2G <= RGB(23 downto 16);
		C3B <= RGB(23 downto 16);
	when "0010" => -- Only G
		C1R <= RGB(15 downto 8);
		C2G <= RGB(15 downto 8);
		C3B <= RGB(15 downto 8);
	when "0011" => -- Only B
		C1R <= RGB( 7 downto  0);
		C2G <= RGB( 7 downto  0);
		C3B <= RGB( 7 downto  0);
	when "0100" => -- normal HSV tri-output
		C1R <= HSV(23 downto 16);
		C2G <= HSV(15 downto 8);
		C3B <= HSV( 7 downto  0);
	when "0101" => -- Only H
		C1R <= HSV(23 downto 16);
		C2G <= HSV(23 downto 16);
		C3B <= HSV(23 downto 16);
	when "0110" => -- Only S
		C1R <= HSV(15 downto 8);
		C2G <= HSV(15 downto 8);
		C3B <= HSV(15 downto 8);
	when "0111" => -- Only V
		C1R <= HSV( 7 downto  0);
		C2G <= HSV( 7 downto  0);
		C3B <= HSV( 7 downto  0);	
	when others => -- normal RGB output
		C1R <= RGB(23 downto 16);
		C2G <= RGB(15 downto 8);
		C3B <= RGB( 7 downto  0);
end case;

end process;

end vM;

