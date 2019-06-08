#python3 RGBgen.py $1

ghdl -a --ieee=synopsys pipeflop.vhdl 
ghdl -a --ieee=synopsys tb_pipe.vhdl 
ghdl -e --ieee=synopsys pipetb
ghdl -r --ieee=synopsys pipetb --vcd=test.vcd --stop-time=300ns

gtkwave test.vcd 
