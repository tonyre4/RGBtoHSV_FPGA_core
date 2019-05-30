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
signal max,min,diff,fdiff : unsigned(R'length-1 downto 0);

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

process (diff)
begin
	if diff="00000000" then
		fdiff <= "00000001";
	else
		fdiff <= diff;
	end if;
end process;

S0:entity work.divider (simple) generic map(GmBt43'length) port map(GmBt43,fdiff,S0div);
S1:entity work.divider (simple) generic map(BmRt43'length) port map(BmRt43,fdiff,S1div);
S2:entity work.divider (simple) generic map(RmGt43'length) port map(RmGt43,fdiff,S2div);

S0sum <= S0div + to_unsigned(  0,S0div'length);
S1sum <= S1div + to_unsigned( 85,S1div'length);
S2sum <= S2div + to_unsigned(171,S2div'length);

process(selector,diff)
begin
	if diff="00000000" then
		H <= "00000000";
	else
		case selector is
			when "100"  => H <= S0sum(7 downto 0);
			when "010"  => H <= S1sum(7 downto 0);
			when "001"  => H <= S2sum(7 downto 0);
			when others => H <= "00000000";
		end case;
	end if;
end process;

end architecture;



architecture complex of RGBtoHSV is

signal Ru,Gu,Bu : unsigned(R'length-1 downto 0);
signal max,min,diff,fdiff : unsigned(R'length-1 downto 0);

signal selector : std_logic_vector(2 downto 0);

signal difft255,Sbuff : unsigned(diff'length+8-1 downto 0);

--Hue
signal GmB,BmG,BmR,RmB,RmG,GmR : unsigned(Ru'length-1 downto 0);
signal GmBt60,BmGt60,BmRt60,RmBt60,RmGt60,GmRt60 : unsigned(Ru'length+6-1 downto 0);
signal S0div,S1div,S2div : unsigned(RmG'length-1+6 downto 0);
signal S0sum,S1sum,S2sum : unsigned(RmG'length-1+6 downto 0);
signal S3div,S4div,S5div : unsigned(RmG'length-1+6 downto 0);
signal S3sum,S4sum,S5sum : unsigned(RmG'length-1+6 downto 0);

signal S0t255,S1t255,S2t255 : unsigned(RmG'length-1+6+8 downto 0);
signal S0d360,S1d360,S2d360 : unsigned(RmG'length-1+6+8 downto 0);
signal S3t255,S4t255,S5t255 : unsigned(RmG'length-1+6+8 downto 0);
signal S3d360,S4d360,S5d360 : unsigned(RmG'length-1+6+8 downto 0);

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

--Substractions
GmB <= Gu-Bu;
BmG <= Bu-Gu;
BmR <= Bu-Ru;
RmB <= Ru-Bu;
RmG <= Ru-Gu;
GmR <= Gu-Ru;

--60 times each Substraction
GmBt60 <= GmB*"111100";
BmGt60 <= BmR*"111100";
BmRt60 <= RmG*"111100";
RmBt60 <= GmB*"111100";
RmGt60 <= BmR*"111100";
GmRt60 <= RmG*"111100";

--To fix division by 0
process (diff)
begin
	if diff="00000000" then
		fdiff <= "00000001";
	else
		fdiff <= diff;
	end if;
end process;

--Divider blocks
--60timesSubs/diff
S0:entity work.divider (simple) generic map(GmBt60'length) port map(GmBt60,fdiff,S0div);
S1:entity work.divider (simple) generic map(BmGt60'length) port map(BmGt60,fdiff,S1div);
S2:entity work.divider (simple) generic map(BmRt60'length) port map(BmRt60,fdiff,S2div);
S3:entity work.divider (simple) generic map(RmBt60'length) port map(RmBt60,fdiff,S3div);
S4:entity work.divider (simple) generic map(RmGt60'length) port map(RmGt60,fdiff,S4div);
S5:entity work.divider (simple) generic map(GmRt60'length) port map(GmRt60,fdiff,S5div);

--Selector
--000 - Rmax and G>B
--001 - Rmax and B>G
--010 - Gmax and B>R
--011 - Gmax and R>B
--100 - Bmax and R>G
--101 - Bmax and G>R
--110 - H indefinido

--Solving addings or substractions
s0sum <= s0div + to_unsigned(  0,s0div'length);
s1sum <= to_unsigned(360,s1div'length) - s1div;
s2sum <= s2div + to_unsigned(120,s2div'length);
s3sum <= to_unsigned(120,s3div'length) - s3div;
s4sum <= s4div + to_unsigned( 240,s4div'length);
s5sum <= to_unsigned(240,s5div'length) - s4div;

--255 times each sum
S0t255 <= "11111111"*s0sum;
S1t255 <= "11111111"*s1sum;
S2t255 <= "11111111"*s2sum;
S3t255 <= "11111111"*s3sum;
S4t255 <= "11111111"*s4sum;
S5t255 <= "11111111"*s5sum;

--dividing by 360 the multiplication
S0d360 <= S0t255/to_unsigned(360,S0d360'length);
S1d360 <= S1t255/to_unsigned(360,S1d360'length);
S2d360 <= S2t255/to_unsigned(360,S2d360'length);
S3d360 <= S3t255/to_unsigned(360,S3d360'length);
S4d360 <= S4t255/to_unsigned(360,S4d360'length);
S5d360 <= S5t255/to_unsigned(360,S5d360'length);

process(diff,selector)
begin
	--For fix division by 0
	if diff>"00000000" then
		case selector is
			when "000"  => H <= S0d360(8 downto 1);
			when "001"  => H <= S1d360(8 downto 1);
			when "010"  => H <= S2d360(8 downto 1);
			when "011"  => H <= S3d360(8 downto 1);
			when "100"  => H <= S4d360(8 downto 1);
			when "101"  => H <= S5d360(8 downto 1);
			
			--when "000"  => H <= S0d360(7 downto 0);
			--when "001"  => H <= S1d360(7 downto 0);
			--when "010"  => H <= S2d360(7 downto 0);
			--when "011"  => H <= S3d360(7 downto 0);
			--when "100"  => H <= S4d360(7 downto 0);
			--when "101"  => H <= S5d360(7 downto 0);
			when others => H <= "00000000";
		end case;
	else
		H <= "00000000";
	end if;
end process;

end complex;

architecture complex2 of RGBtoHSV is


signal Ru,Gu,Bu : unsigned(R'length-1 downto 0);
signal max,fmax,min,diff,fdiff : unsigned(R'length-1 downto 0);

signal selector : std_logic_vector(2 downto 0);

signal difft255,Sbuff : unsigned(diff'length+8-1 downto 0);

--Hue
signal GmB,BmG,BmR,RmB,RmG,GmR : unsigned(Ru'length-1 downto 0);
signal GmBt60,BmGt60,BmRt60,RmBt60,RmGt60,GmRt60 : unsigned(Ru'length+6-1 downto 0);
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


diff<= max - min;
difft255 <= diff*"11111111";

--To fix division by 0
process (max)
begin
	if max="00000000" then
		fmax <= "00000001";
	else
		fmax <= max;
	end if;
end process;

Scalc: entity work.divider (simple) generic map(difft255'length) port map(difft255,fmax,Sbuff);

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

--Substractions
GmB <= Gu-Bu;
BmG <= Bu-Gu;
BmR <= Bu-Ru;
RmB <= Ru-Bu;
RmG <= Ru-Gu;
GmR <= Gu-Ru;

--60 times each Substraction
GmBt60 <= GmB*"111100";
BmGt60 <= BmG*"111100";
BmRt60 <= BmR*"111100";
RmBt60 <= RmB*"111100";
RmGt60 <= RmG*"111100";
GmRt60 <= GmR*"111100";

--To fix division by 0
process (diff)
begin
	if diff="00000000" then
		fdiff <= "00000001";
	else
		fdiff <= diff;
	end if;
end process;

--Divider blocks
--60timesSubs/diff
S0:entity work.divider (simple) generic map(GmBt60'length) port map(GmBt60,fdiff,S0div);
S1:entity work.divider (simple) generic map(BmGt60'length) port map(BmGt60,fdiff,S1div);
S2:entity work.divider (simple) generic map(BmRt60'length) port map(BmRt60,fdiff,S2div);
S3:entity work.divider (simple) generic map(RmBt60'length) port map(RmBt60,fdiff,S3div);
S4:entity work.divider (simple) generic map(RmGt60'length) port map(RmGt60,fdiff,S4div);
S5:entity work.divider (simple) generic map(GmRt60'length) port map(GmRt60,fdiff,S5div);

--Selector
--000 - Rmax and G>B
--001 - Rmax and B>G
--010 - Gmax and B>R
--011 - Gmax and R>B
--100 - Bmax and R>G
--101 - Bmax and G>R
--110 - H indefinido

--Solving addings or substractions
s0sum <= to_unsigned(  0,s0div'length) + s0div;
s1sum <= to_unsigned(360,s1div'length) - s1div;
s2sum <= to_unsigned(120,s2div'length) + s2div;
s3sum <= to_unsigned(120,s3div'length) - s3div;
s4sum <= to_unsigned(240,s4div'length) + s4div;
s5sum <= to_unsigned(240,s5div'length) - s5div;


process(diff,selector)
begin
	--For fix division by 0
	if diff>"00000000" then
		case selector is
			when "000"  => H <= s0sum(8 downto 1);
			when "001"  => H <= s1sum(8 downto 1);
			when "010"  => H <= s2sum(8 downto 1);
			when "011"  => H <= s3sum(8 downto 1);
			when "100"  => H <= s4sum(8 downto 1);
			when "101"  => H <= s5sum(8 downto 1);
			when others => H <= "00000000";
		end case;
	else
		H <= "00000000";
	end if;
end process;

end architecture;


architecture simplest of RGBtoHSV is


signal Ru,Gu,Bu : unsigned(R'length-1 downto 0);
signal max,fmax,min,diff,fdiff : unsigned(R'length-1 downto 0);

signal selector : std_logic_vector(2 downto 0);

signal difft255,Sbuff : unsigned(diff'length+8-1 downto 0);

--Hue
--signal GmB,BmG,BmR,RmB,RmG,GmR : unsigned(Ru'length-1 downto 0);
--signal GmBt60,BmGt60,BmRt60,RmBt60,RmGt60,GmRt60 : unsigned(Ru'length+6-1 downto 0);
--signal S0div,S1div,S2div : unsigned(RmGt60'length-1+6 downto 0);
--signal S0sum,S1sum,S2sum : unsigned(S0div'length-1+6 downto 0);
--signal S3div,S4div,S5div : unsigned(RmGt60'length-1+6 downto 0);
--signal S3sum,S4sum,S5sum : unsigned(S0div'length-1+6 downto 0);

--Hue
signal GmB,BmG,BmR,RmB,RmG,GmR : unsigned(Ru'length-1 downto 0);
signal GmBt60,BmGt60,BmRt60,RmBt60,RmGt60,GmRt60 : unsigned(Ru'length+6-1 downto 0);
signal S0div,S1div,S2div : unsigned(RmG'length-1+6 downto 0);
signal S0sum,S1sum,S2sum : unsigned(RmG'length-1+6 downto 0);
signal S3div,S4div,S5div : unsigned(RmG'length-1+6 downto 0);
signal S3sum,S4sum,S5sum : unsigned(RmG'length-1+6 downto 0);

--signal GmBt60,BmGt60,BmRt60,RmBt60,RmGt60,GmRt60 : unsigned(Ru'length+7-1 downto 0);
--signal S0div,S1div,S2div : unsigned(RmG'length+6 downto 0);
--signal S0sum,S1sum,S2sum : unsigned(RmG'length+6 downto 0);
--signal S3div,S4div,S5div : unsigned(RmG'length+6 downto 0);
--signal S3sum,S4sum,S5sum : unsigned(RmG'length+6 downto 0);


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
	if (Ru>=Gu) then
		max<= Ru;
	else
		max<= Gu;
	end if;
else
	if (Gu>=Bu) then
		max<= Gu;
	else
		max<= Bu;
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
if (Ru<Bu) then
	if (Ru<Bu) then
		min<= Ru;
	else
		min<= Bu;
	end if;
else
	if (Gu<Bu) then
		min<= Gu;
	else
		min<= Bu;
	end if;
end if;
end process;

--For fix division by 0
process (max)
begin
	if max="00000000" then
		fmax <= "00000001";
	else
		fmax <= max;
	end if;
end process;

diff<= max - min;
difft255 <= diff*"11111111";

Scalc: entity work.divider (simple) generic map(difft255'length) port map(difft255,fmax,Sbuff);

process(max)
begin
	if max="00000000" then
		S <= (others => '0');
	else
		S <= Sbuff(7 downto 0);
	end if;
end process;
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

--Substractions
GmB <= Gu-Bu;
BmG <= Bu-Gu;
BmR <= Bu-Ru;
RmB <= Ru-Bu;
RmG <= Ru-Gu;
GmR <= Gu-Ru;

--60 times each Substraction
GmBt60 <= GmB*"111100";
BmGt60 <= BmG*"111100";
BmRt60 <= BmR*"111100";
RmBt60 <= RmB*"111100";
RmGt60 <= RmG*"111100";
GmRt60 <= GmR*"111100";

--GmBt60 <= GmB*"0111100";
--BmGt60 <= BmR*"0111100";
--BmRt60 <= RmG*"0111100";
--RmBt60 <= GmB*"0111100";
--RmGt60 <= BmR*"0111100";
--GmRt60 <= RmG*"0111100";

--To fix division by 0
process (diff)
begin
	if diff="00000000" then
		fdiff <= "00000001";
	else
		fdiff <= diff;
	end if;
end process;

--Divider blocks
--60timesSubs/diff
S0:entity work.divider (simple) generic map(GmBt60'length) port map(GmBt60,fdiff,S0div);
S1:entity work.divider (simple) generic map(BmGt60'length) port map(BmGt60,fdiff,S1div);
S2:entity work.divider (simple) generic map(BmRt60'length) port map(BmRt60,fdiff,S2div);
S3:entity work.divider (simple) generic map(RmBt60'length) port map(RmBt60,fdiff,S3div);
S4:entity work.divider (simple) generic map(RmGt60'length) port map(RmGt60,fdiff,S4div);
S5:entity work.divider (simple) generic map(GmRt60'length) port map(GmRt60,fdiff,S5div);

--Selector
--000 - Rmax and G>B
--001 - Rmax and B>G
--010 - Gmax and B>R
--011 - Gmax and R>B
--100 - Bmax and R>G
--101 - Bmax and G>R
--110 - H indefinido

--Solving addings or substractions
s0sum <= to_unsigned(  0,s0div'length) + s0div;
s1sum <= to_unsigned(360,s1div'length) - s1div;
s2sum <= to_unsigned(120,s2div'length) + s2div;
s3sum <= to_unsigned(120,s3div'length) - s3div;
s4sum <= to_unsigned(240,s4div'length) + s4div;
s5sum <= to_unsigned(240,s5div'length) - s5div;

process(max,Ru,Gu,Bu)
begin
	if max=Ru then
		if Gu>Bu then
			selector <= "000";
		else
			selector <= "001";
		end if;
	elsif max=Gu then
		if Bu>Ru then
			selector <= "010";
		else
			selector <= "011";
		end if;
	elsif max=Bu then
		if Ru>Gu then
			selector <= "100";
		else
			selector <= "101";
		end if;
	else
		selector <= "111";
	end if;
end process;

process(diff,selector)
begin
	--For fix division by 0
	if diff="00000000" then
		H <= "00000000";
	else
		case selector is
			when "000"  => H <= s0sum(8 downto 1);
			when "001"  => H <= s1sum(8 downto 1);
			when "010"  => H <= s2sum(8 downto 1);
			when "011"  => H <= s3sum(8 downto 1);
			when "100"  => H <= s4sum(8 downto 1);
			when "101"  => H <= s5sum(8 downto 1);
			when others => H <= "00000000";
		end case;
	end if;
end process;

end architecture;
