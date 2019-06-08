----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:27:41 09/23/2016 
-- Design Name: 
-- Module Name:    Binarization - Behavioral 
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

entity Binarization is
    Port ( BWin : in  STD_LOGIC_VECTOR (7 downto 0);
           BWout : out  STD_LOGIC_VECTOR (7 downto 0));
end Binarization;

architecture Behavioral of Binarization is

begin

BWout<= "00000000" when BWin < "00100000" else
		  "11111111";


end Behavioral;

