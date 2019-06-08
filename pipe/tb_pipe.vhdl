library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity pipetb is
end entity;


architecture text_io of pipetb is
	file file_in1 : text open read_mode is  "reg.txt";
	file file_out1 : text open write_mode is "delayed.txt";
	signal in1: std_logic_vector(7 downto 0);
	signal out1: std_logic_vector(7 downto 0);
	signal clk: std_logic := '0';
	signal rst: std_logic := '1';
	signal write_on: std_logic := '0';
begin
	clk <=  '1' after 5 ns when clk = '0' else
        	'0' after 5 ns when clk = '1';
	
  rst <=  '0' after 10   ns when rst = '1' else
        	'1' after 50  ns when rst = '0';
  

	--top: entity work.rgbtohsv (simplest) port map(in1,in2,in3,out1,out2,out3);	
	top: entity work.pipeflopstd (series) generic map (3,8) port map(clk,rst,in1,out1);	


	in11: process(clk)
		variable line_in: LINE;
		variable input_tmp: INTEGER;
	begin
		if clk'event and clk = '1' then
			if not (ENDFILE(file_in1)) then
				READLINE(file_in1,line_in);
				READ(line_in, input_tmp);
				in1<=STD_LOGIC_VECTOR(to_unsigned(input_tmp,8));
				write_on <= '1';
			end if;
		end if;
	end process;

	out11: process(clk)
		variable line_out: LINE;
		variable output_tmp: INTEGER;
	begin
		if clk'event and clk = '1' and write_on='1' then
			if not (ENDFILE(file_in1)) then
				--output_tmp := CONV_INTEGER(unsigned(out1));
				output_tmp := to_INTEGER(unsigned(out1));
				WRITE(line_out,output_tmp);
				WRITELINE(file_out1,line_out);
			end if;
		end if;
	end process;

end architecture;
