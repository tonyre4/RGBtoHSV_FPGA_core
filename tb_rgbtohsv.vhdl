library IEEE;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity rgbtohsvtb is
end entity;


architecture text_io of rgbtohsvtb is
	file file_in1 : text open read_mode is  "R.txt";
	file file_in2 : text open read_mode is  "G.txt";
	file file_in3 : text open read_mode is  "B.txt";
	file file_out1 : text open write_mode is "H.txt";
	file file_out2 : text open write_mode is "S.txt";
	file file_out3 : text open write_mode is "V.txt";
	signal in1,in2,in3: std_logic_vector(7 downto 0);
	signal out1,out2,out3 : unsigned(7 downto 0);
	signal clk: std_logic := '0';
begin
	clk <=  '1' after 5 ns when clk = '0' else
        	'0' after 5 ns when clk = '1';

	D1: entity work.rgbtohsv (behaviorial) port map(in1,in2,in3,open,out2,out3);	

	in11: process(clk)
		variable line_in: LINE;
		variable input_tmp: INTEGER;
	begin
		if clk'event and clk = '1' then
			if not (ENDFILE(file_in1)) then
				READLINE(file_in1,line_in);
				READ(line_in, input_tmp);
				in1<=STD_LOGIC_VECTOR(to_unsigned(input_tmp,8));
			end if;
		end if;
	end process;

	in21: process(clk)
		variable line_in: LINE;
		variable input_tmp: INTEGER;
	begin
		if clk'event and clk = '1' then
			if not (ENDFILE(file_in2)) then
				READLINE(file_in2,line_in);
				READ(line_in, input_tmp);
				--in2<=CONV_STD_LOGIC_VECTOR(input_tmp,8);
				in2<=STD_LOGIC_VECTOR(to_unsigned(input_tmp,8));
			end if;
		end if;
	end process;
	
	in31: process(clk)
		variable line_in: LINE;
		variable input_tmp: INTEGER;
	begin
		if clk'event and clk = '1' then
			if not (ENDFILE(file_in3)) then
				READLINE(file_in3,line_in);
				READ(line_in, input_tmp);
				--in2<=CONV_STD_LOGIC_VECTOR(input_tmp,8);
				in3<=STD_LOGIC_VECTOR(to_unsigned(input_tmp,8));
			end if;
		end if;
	end process;

	out11: process(clk)
		variable line_out: LINE;
		variable output_tmp: INTEGER;
	begin
		if clk'event and clk = '1' then
			if not (ENDFILE(file_in1)) then
				--output_tmp := CONV_INTEGER(unsigned(out1));
				output_tmp := to_INTEGER(unsigned(out1));
				WRITE(line_out,output_tmp);
				WRITELINE(file_out1,line_out);
			end if;
		end if;
	end process;
	out21: process(clk)
		variable line_out: LINE;
		variable output_tmp: INTEGER;
	begin
		if clk'event and clk = '1' then
			if not (ENDFILE(file_in1)) then
				--output_tmp := CONV_INTEGER(unsigned(out1));
				output_tmp := to_INTEGER(unsigned(out2));
				WRITE(line_out,output_tmp);
				WRITELINE(file_out2,line_out);
			end if;
		end if;
	end process;
	
	out31: process(clk)
		variable line_out: LINE;
		variable output_tmp: INTEGER;
	begin
		if clk'event and clk = '1' then
			if not (ENDFILE(file_in1)) then
				--output_tmp := CONV_INTEGER(unsigned(out1));
				output_tmp := to_INTEGER(unsigned(out3));
				WRITE(line_out,output_tmp);
				WRITELINE(file_out3,line_out);
			end if;
		end if;
	end process;
end text_io;
