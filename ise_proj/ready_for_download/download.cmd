setMode -bscan
setCable -p auto
identify
assignfile -p 3 -file fmc_dvidp_dvi_passthrough_demo.bit
program -p 3
quit
