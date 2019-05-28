ghdl -a --ieee=synopsys divider.vhdl 
ghdl -a --ieee=synopsys rgbtohsv.vhdl 
ghdl -a --ieee=synopsys tb_rgbtohsv.vhdl 
ghdl -e --ieee=synopsys rgbtohsvtb
ghdl -r --ieee=synopsys  rgbtohsvtb --vcd=test.vcd --stop-time=$1
#maria leon pixels=540000
#ghdl -r --ieee=synopsys  rgbtohsvtb --vcd=test.vcd --stop-time=5399975ns
#test
#ghdl -r --ieee=synopsys  rgbtohsvtb --vcd=test.vcd --stop-time=5399975ns

#gtkwave test.vcd 
python3 hsvcomparison.py
