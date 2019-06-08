library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeflopstd is
generic (dly     : integer := 2;
         rlength : integer := 8);
port(	clk,rst :  in std_logic;
      Rin     :  in std_logic_vector(rlength-1 downto 0);
	    Rout    : out std_logic_vector(rlength-1 downto 0));
end entity;

architecture main of pipeflopstd is
begin
  process(clk,rst)
  begin
      if clk='1' and clk'event then
        if rst='1' then
          Rout <= (others => '0');
        else
          Rout <= Rin;
        end if;
      end if;
  end process;
end architecture;


architecture series of pipeflopstd is
 type xts is array (0 to dly) of std_logic_vector(rlength-1 downto 0);
 signal conn : xts;
begin

conn(0) <= Rin;
Rout <= conn(dly);

flopchain:
for i in 0 to dly-1 generate
	  midd: entity work.pipeflopstd (main) port map(clk,rst,conn(i),conn(i+1));	
end generate;

end architecture;
