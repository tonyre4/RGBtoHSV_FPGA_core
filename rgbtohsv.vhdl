library ieee;
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

entity RGBtoHSV is
port(	R,G,B:  in   std_logic_vector(7 downto 0);
	H:  out  unsigned(7 downto 0);
	S,V:  out  unsigned(7 downto 0));
	--clk,rst: in std_logic );
end RGBtoHSV;

architecture behaviorial of RGBtoHSV is

signal Ru,Gu,Bu : unsigned(R'length-1 downto 0);
signal max,min,diff : unsigned(R'length-1 downto 0);

signal RmG,BmR,GmB : unsigned(R'length-1 downto 0);
signal selector : std_logic_vector(2 downto 0);

--6 bits for 42_10=101011_2 number
signal RmGt43,BmRt43,GmBt43 : unsigned(RmG'length-1+6 downto 0);
signal S0div,S1div,S2div : unsigned(RmG'length-1+6 downto 0);
signal S0sum,S1sum,S2sum : unsigned(RmG'length-1+6 downto 0);
signal difft255,Sbuff : unsigned(diff'length+8-1 downto 0);

begin
---------------
--Calculating V 
-- V = max(colors)

Ru <= unsigned(R);
Gu <= unsigned(G);
Bu <= unsigned(B);

getmax:process (Ru,Gu,Bu)
begin
if (Ru>=Bu) then
	if (Ru>=Gu) then
		max<= Ru;
		selector <= "100";
	else
		max<= Gu;
		selector <= "010";
	end if;
else
	if (Gu>=Bu) then
		max<= Gu;
		selector <= "010";
	else
		max<= Bu;
		selector <= "001";
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
	if (Bu>Gu) then
		min<= Gu;
	else
		min<= Bu;
	end if;
else
	if (Ru>Gu) then
		min<= Gu;
	else
		min<= Ru;
	end if;
end if;
end process;

diff<= max - min;
difft255 <= diff*"11111111";

Scalc: entity work.divider (simple) generic map(difft255'length) port map(difft255,max,Sbuff);

S <= Sbuff(7 downto 0);

----------------------------
-------END calc S-----------
----------------------------

-----------------------------
--Calculating H
GmB <= Gu-Bu;
BmR <= Bu-Ru;
RmG <= Ru-Gu;

GmBt43 <= GmB*"101011";
BmRt43 <= BmR*"101011";
RmGt43 <= RmG*"101011";

S0:entity work.divider (simple) generic map(GmBt43'length) port map(GmBt43,max,S0div);
S1:entity work.divider (simple) generic map(BmRt43'length) port map(BmRt43,max,S1div);
S2:entity work.divider (simple) generic map(RmGt43'length) port map(RmGt43,max,S2div);

S0sum <= S0div + to_unsigned(  0,S0div'length);
S1sum <= S1div + to_unsigned( 85,S1div'length);
S2sum <= S2div + to_unsigned(171,S2div'length);

process(selector,S0sum,S1sum,S2sum)
begin
	case selector is
		when "100"  => H <= S0sum(7 downto 0);
		when "010"  => H <= S1sum(7 downto 0);
		when "001"  => H <= S2sum(7 downto 0);
		when others => H <= "11111111";
	end case;
end process;

end behaviorial;
