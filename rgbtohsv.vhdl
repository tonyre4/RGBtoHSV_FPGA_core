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

architecture paper of RGBtoHSV is

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

S0:entity work.divider (simple) generic map(GmBt43'length) port map(GmBt43,diff,S0div);
S1:entity work.divider (simple) generic map(BmRt43'length) port map(BmRt43,diff,S1div);
S2:entity work.divider (simple) generic map(RmGt43'length) port map(RmGt43,diff,S2div);

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

end architecture;



architecture complex of RGBtoHSV is

signal Ru,Gu,Bu : unsigned(R'length-1 downto 0);
signal max,min,diff : unsigned(R'length-1 downto 0);

signal selector : std_logic_vector(2 downto 0);

signal difft255,Sbuff : unsigned(diff'length+8-1 downto 0);

--Hue
signal GmB,BmG,BmR,RmB,RmG,GmR : unsigned(Ru'length-1 downto 0);
signal GmBt60,BmGt60,BmRt60,RmBt60,RmGt60,GmRt60 : unsigned(Ru'length+8-1 downto 0);
signal S0div,S1div,S2div : unsigned(RmG'length-1+6 downto 0);
signal S0sum,S1sum,S2sum : unsigned(RmG'length-1+6 downto 0);
signal S3div,S4div,S5div : unsigned(RmG'length-1+6 downto 0);
signal S3sum,S4sum,S5sum : unsigned(RmG'length-1+6 downto 0);

begin
---------------
--Calculating V 
-- V = max(colors)

Ru <= unsigned(R);
Gu <= unsigned(G);
Bu <= unsigned(B);

--Selector
--000 - Rmax and G>B
--001 - Rmax and B>G
--010 - Gmax and B>R
--011 - Gmax and R>B
--100 - Bmax and R>G
--101 - Bmax and G>R

getmax:process (Ru,Gu,Bu)
begin
if (Ru>=Bu) then
	if (Ru>=Gu) then --max R
		max<= Ru;
		if Gu>=Bu then
			selector <= "000";
			min <= Bu;
		else
			selector <= "001";
			min <= Gu;
		end if;
	else -- max Green
		max<= Gu;
		if Bu>=Ru then
			selector <= "010";
			min <= Ru;
		else
			selector <= "011";
			min <= Bu;
		end if;
	end if;
else
	if (Gu>=Bu) then --max Green
		max<= Gu;
		if Bu>=Ru then
			selector <= "010";
			min <= Ru;
		else
			selector <= "011";
			min <= Bu;
		end if;
	else --max Blue
		max<= Bu;
		if Ru>=Gu then
			selector <= "100";
			min <= Gu;
		else
			selector <= "101";
			min <= Ru;
		end if;
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

diff<= max - min;
difft255 <= diff*"11111111";

Scalc: entity work.divider (simple) generic map(difft255'length) port map(difft255,max,Sbuff);

S <= Sbuff(7 downto 0);

----------------------------
-------END calc S-----------
----------------------------

-----------------------------
--Calculating H
--Selector
--000 - Rmax and G>B
--001 - Rmax and B>G
--010 - Gmax and B>R
--011 - Gmax and R>B
--100 - Bmax and R>G
--101 - Bmax and G>R

GmB <= Gu-Bu;
BmG <= Bu-Gu;
BmR <= Bu-Ru;
RmB <= Ru-Bu;
RmG <= Ru-Gu;
GmR <= Gu-Ru;

GmBt60 <= GmB*"111100";
BmGt60 <= BmR*"111100";
BmRt60 <= RmG*"111100";
RmBt60 <= GmB*"111100";
RmGt60 <= BmR*"111100";
GmRt60 <= RmG*"111100";

S0:entity work.divider (simple) generic map(GmBt60'length) port map(GmBt60,diff,S0div);
S1:entity work.divider (simple) generic map(BmGt60'length) port map(BmGt60,diff,S1div);
S2:entity work.divider (simple) generic map(BmRt60'length) port map(BmRt60,diff,S2div);
S3:entity work.divider (simple) generic map(RmBt60'length) port map(RmBt60,diff,S3div);
S4:entity work.divider (simple) generic map(RmGt60'length) port map(RmGt60,diff,S4div);
S5:entity work.divider (simple) generic map(GmRt60'length) port map(GmRt60,diff,S5div);

--Selector
--000 - Rmax and G>B
--001 - Rmax and B>G
--010 - Gmax and B>R
--011 - Gmax and R>B
--100 - Bmax and R>G
--101 - Bmax and G>R
s0sum <= s0div + to_unsigned(  0,s0div'length);
s1sum <= to_unsigned(360,s1div'length) - s1div;
s2sum <= s2div + to_unsigned(120,s2div'length);
s3sum <= to_unsigned(120,s3div'length) - s3div;
s4sum <= s4div + to_unsigned( 240,s4div'length);
s5sum <= to_unsigned(240,s5div'length) - s4div;

process(selector)
begin
	case selector is
		when "000"  => H <= s0sum(7 downto 0);
		when "001"  => H <= s1sum(7 downto 0);
		when "010"  => H <= s2sum(7 downto 0);
		when "011"  => H <= s3sum(7 downto 0);
		when "100"  => H <= s4sum(7 downto 0);
		when "101"  => H <= s5sum(7 downto 0);
		when others => H <= "00000000";
	end case;
end process;

end complex;
