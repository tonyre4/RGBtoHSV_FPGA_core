`timescale  100 ps / 10 ps

/*
------------------------------------------------------------------
--      _____
--     /     \
--    /____   \____
--   / \===\   \==/
--  /___\===\___\/  AVNET
--       \======/
--        \====/    
------------------------------------------------------------------
--
-- This design is the property of Avnet.  Publication of this
-- design is not authorized without written consent from Avnet.
-- 
-- Please direct any questions to:  technical.support@avnet.com
--
-- Disclaimer:
--    Avnet, Inc. makes no warranty for the use of this code or design.
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
--    any errors, which may appear in this code, nor does it make a commitment
--    to update the information contained herein. Avnet, Inc specifically
--    disclaims any implied warranties of fitness for a particular purpose.
--                     Copyright(c) 2010 Avnet, Inc.
--                             All rights reserved.
--
------------------------------------------------------------------
--
-- Create Date:         Jan 20, 2010
-- Design Name:         DVI_Pass_Through_Demo
-- Module Name:         FMC_DVIDP_CONFIG
-- Project Name:        DVI_Pass_Through_Demo
-- Target Devices:      Spartan-6
-- Avnet Boards:        FMC-DVI/DP
--
-- Tool versions:       ISE 11.4
--
-- Description:         This module is a wrapper for a Picoblaze processor
--                      to control the FMC-DVI/DP module via I2C
--
-- Dependencies:        
--
-- Revision:            Jan 20, 2010: 1.00 Initial Version
--
------------------------------------------------------------------
*/

module FMC_DVIDP_CONFIG(
	CLK, 
   DIPSW_IN,
   PUSHB_IN,
   RESET_OUT,
	SCL_OUT, SDA_OUT, SDA_IN
	);

// Master Clock input
input			CLK;

// DIPSW
input [7:0] DIPSW_IN;

// PUSHB
input [3:0] PUSHB_IN;

// CSR
output                  RESET_OUT;

// I2C bus interface
output			SCL_OUT = 1'b1;
output			SDA_OUT = 1'b1;
input			SDA_IN;

//------- Picoblaze data bus -------
wire	[7:0]	adr, wr_dat, rd_dat;
wire			rd_strobe, wr_strobe;

//------- PicoBlaze data bus stuff ----------
parameter [7:0]	csr_reg_adr  = 8'h00;
parameter [7:0]	i2c_reg_adr  = 8'h01;
parameter [7:0]   dipsw_adr    = 8'h02;
parameter [7:0]   pushb_adr    = 8'h03;

// CSR register
reg 			RESET_OUT;
always @(posedge CLK) 
	begin
	RESET_OUT <=#1 (adr == csr_reg_adr) && wr_strobe ? wr_dat[0] : RESET_OUT;
	end

// I2C register
reg 			SCL_OUT, SDA_OUT;
always @(posedge CLK) 
	begin
	SCL_OUT <=#1 (adr == i2c_reg_adr) && wr_dat[3] && wr_strobe ? wr_dat[2] : SCL_OUT;
	SDA_OUT <=#1 (adr == i2c_reg_adr) && wr_dat[1] && wr_strobe ? wr_dat[0] : SDA_OUT;
	end
wire	[7:0]	i2c_reg_rd = {7'b0000_000, SDA_IN};

// DIPSW register
wire  [7:0] dipsw_rd = DIPSW_IN;

// PUSHB register
wire  [7:0] pushb_rd = {4'b0000, PUSHB_IN};

// generate read data
assign rd_dat =
	(adr == i2c_reg_adr) ? i2c_reg_rd :
   (adr == dipsw_adr) ? dipsw_rd :
   (adr == pushb_adr) ? pushb_rd :
	8'h00; 



//------- Picoblaze Program -------
wire	[9:0]	instruction_address;
wire	[17:0]	instruction;
PB_FMC_DVIDP_CONFIG prog (
    .CLK(CLK), .ADDRESS(instruction_address), .INSTRUCTION(instruction),
	.LOAD_CLK(1'b0), .LOAD_ADDRESS(9'b0_0000_0000), .LOAD_INSTRUCTION(17'b0_0000_0000_0000_0000), .LOAD_WE(1'b0)
	);

// ------- Picoblaze Processor -------
wire 		interrupt = 0;
wire		interrupt_ack;
kcpsm3 cpu (
    .clk(CLK), 
    .interrupt(interrupt), .interrupt_ack(interrupt_ack),
    .address(instruction_address), .instruction(instruction), 
    .port_id(adr), .in_port(rd_dat), .out_port(wr_dat), 
    .read_strobe(rd_strobe), .write_strobe(wr_strobe), 
    .reset(1'b0)
    );

endmodule
