library ieee;
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

entity RGBtoHSV is
port(	R,G,B:  in   std_logic_vector(7 downto 0);
	H:  out  unsigned(8 downto 0);
	S,V:  out  unsigned(7 downto 0));
	--clk,rst: in std_logic );
end RGBtoHSV;

architecture behaviorial of RGBtoHSV is

signal Ru,Gu,Bu : unsigned(R'length-1 downto 0);
signal max,min,diff : unsigned(R'length-1 downto 0);


begin
---------------
--Calculating V 
-- V = max(colors)

Ru <= unsigned(R);
Gu <= unsigned(G);
Bu <= unsigned(B);

getmax:process (Ru,Gu,Bu)
begin
if (Ru>Bu) then
	if (Ru>=Gu) then
		max<= Ru;
	else
		max<= Gu;
	end if;
else
	if (Bu>=Gu) then
		max<= Bu;
	else
		max<= Gu;
	end if;
end if;
end process;
V <= max;
-----------------------------
--------END calc V-----------
-----------------------------


-----------------------------
--Calculating S
-- S =  if V!=0  S <= diff/max
--	else  	 S <= 0

-- diff <= max-min

getmin:process (Ru,Gu,Bu)
begin
if (Ru>Bu) then
	if (Bu>=Gu) then
		min<= Gu;
	else
		min<= Bu;
	end if;
else
	if (Ru>=Gu) then
		min<= Gu;
	else
		min<= Ru;
	end if;
end if;
end process;

diff<= max - min;

Scalc: entity work.divider (behaviorial) port map(diff,max,S);


----------------------------
-------END calc S-----------
----------------------------

-----------------------------
--Calculating H
--getH:process(Ru,Gu,Bu,max)
--begin
--	if (Ru=max) then
--		suma <= to_unsigned(0,suma'length);
--		resta <= Gu+not(Bu)+1;
--	elsif (Gu=max) then
--		suma <= to_unsigned(120,suma'length);
--		resta <= Bu+not(Ru)+1;
--	elsif (Bu=max) then
--		suma <= to_unsigned(240,suma'length);
--		resta <= Ru+not(Gu)+1;
--	end if;
--end process;

--dividendo <= suma+resta;

--Hcalc: entity work.divider (behaviorial) generic map (10) port map(dividendo,diff,Hbuff);

--H <= Hbuff(Hbuff'length-1 downto Hbuff'length-8);

end behaviorial;
