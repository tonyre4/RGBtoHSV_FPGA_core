----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:38:17 09/23/2016 
-- Design Name: 
-- Module Name:    RGB2Gray - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RGB2Gray is
    Port ( Rin : in  STD_LOGIC_VECTOR (7 downto 0);
           Gin : in  STD_LOGIC_VECTOR (7 downto 0);
           Bin : in  STD_LOGIC_VECTOR (7 downto 0);
           BWout : out  STD_LOGIC_VECTOR (7 downto 0));
end RGB2Gray;

architecture Behavioral of RGB2Gray is

signal adding,result: std_logic_vector (7 downto 0);
signal product: std_logic_vector (15 downto 0);

begin

adding <= Rin+Gin+Bin;
product <= adding* "10101011";
BWout <= product (15 downto 8);

end Behavioral;

