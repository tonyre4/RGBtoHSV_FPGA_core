{begin template}
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
-- Module Name:         PB_FMC_DVIDP_CONFIG
-- Project Name:        DVI_Pass_Through_Demo
-- Target Devices:      Spartan-6
-- Avnet Boards:        FMC-DVI/DP
--
-- Tool versions:       ISE 12.2
--
-- Description:         This is a module for storing a program for the KCPSM3 (aka Pico-Blaze)
--                      The code is assembled as "{pico}" (should be pbt3 for spartan 3)
--
--                      Ingredients: 1 18kb Block Ram
--
-- Dependencies:        
--
-- Revision:            Jan 20, 2010: 1.00 Initial Version
--                      Sep 07, 2010: 1.01 Update for 12.2
--
------------------------------------------------------------------
*/

module {name}(
	CLK, ADDRESS, INSTRUCTION,
	LOAD_CLK, LOAD_ADDRESS, LOAD_INSTRUCTION, LOAD_WE
	);

input			CLK;
input	[9:0]	ADDRESS;
output	[17:0]	INSTRUCTION;

// Load interface for reloading program
input			LOAD_CLK;
input	[9:0]	LOAD_ADDRESS;
input	[17:0]	LOAD_INSTRUCTION;
input			LOAD_WE;

RAMB16_S18_S18	#(
      .INIT_00(256'h{INIT_00}),
      .INIT_01(256'h{INIT_01}),	
      .INIT_02(256'h{INIT_02}),	
      .INIT_03(256'h{INIT_03}),	
      .INIT_04(256'h{INIT_04}),	
      .INIT_05(256'h{INIT_05}),	
      .INIT_06(256'h{INIT_06}),	
      .INIT_07(256'h{INIT_07}),	
      .INIT_08(256'h{INIT_08}),	
      .INIT_09(256'h{INIT_09}),	
      .INIT_0A(256'h{INIT_0A}),	
      .INIT_0B(256'h{INIT_0B}),	
      .INIT_0C(256'h{INIT_0C}),	
      .INIT_0D(256'h{INIT_0D}),	
      .INIT_0E(256'h{INIT_0E}),	
      .INIT_0F(256'h{INIT_0F}),	
      .INIT_10(256'h{INIT_10}),	
      .INIT_11(256'h{INIT_11}),	
      .INIT_12(256'h{INIT_12}),	
      .INIT_13(256'h{INIT_13}),	
      .INIT_14(256'h{INIT_14}),	
      .INIT_15(256'h{INIT_15}),	
      .INIT_16(256'h{INIT_16}),	
      .INIT_17(256'h{INIT_17}),	
      .INIT_18(256'h{INIT_18}),	
      .INIT_19(256'h{INIT_19}),	
      .INIT_1A(256'h{INIT_1A}),	
      .INIT_1B(256'h{INIT_1B}),	
      .INIT_1C(256'h{INIT_1C}),	
      .INIT_1D(256'h{INIT_1D}),	
      .INIT_1E(256'h{INIT_1E}),	
      .INIT_1F(256'h{INIT_1F}),	
      .INIT_20(256'h{INIT_20}),	
      .INIT_21(256'h{INIT_21}),	
      .INIT_22(256'h{INIT_22}),	
      .INIT_23(256'h{INIT_23}),	
      .INIT_24(256'h{INIT_24}),	
      .INIT_25(256'h{INIT_25}),	
      .INIT_26(256'h{INIT_26}),	
      .INIT_27(256'h{INIT_27}),	
      .INIT_28(256'h{INIT_28}),	
      .INIT_29(256'h{INIT_29}),	
      .INIT_2A(256'h{INIT_2A}),	
      .INIT_2B(256'h{INIT_2B}),	
      .INIT_2C(256'h{INIT_2C}),	
      .INIT_2D(256'h{INIT_2D}),	
      .INIT_2E(256'h{INIT_2E}),	
      .INIT_2F(256'h{INIT_2F}),	
      .INIT_30(256'h{INIT_30}),	
      .INIT_31(256'h{INIT_31}),	
      .INIT_32(256'h{INIT_32}),	
      .INIT_33(256'h{INIT_33}),	
      .INIT_34(256'h{INIT_34}),	
      .INIT_35(256'h{INIT_35}),	
      .INIT_36(256'h{INIT_36}),	
      .INIT_37(256'h{INIT_37}),	
      .INIT_38(256'h{INIT_38}),	
      .INIT_39(256'h{INIT_39}),	
      .INIT_3A(256'h{INIT_3A}),	
      .INIT_3B(256'h{INIT_3B}),	
      .INIT_3C(256'h{INIT_3C}),	
      .INIT_3D(256'h{INIT_3D}),	
      .INIT_3E(256'h{INIT_3E}),	
      .INIT_3F(256'h{INIT_3F}),
      .INITP_00(256'h{INITP_00}),
      .INITP_01(256'h{INITP_01}),
      .INITP_02(256'h{INITP_02}),	
      .INITP_03(256'h{INITP_03}),	
      .INITP_04(256'h{INITP_04}),	
      .INITP_05(256'h{INITP_05}),	
      .INITP_06(256'h{INITP_06}),	
      .INITP_07(256'h{INITP_07}))
rom(	
	// Port A: Read Port
	.CLKA(CLK), .ADDRA(ADDRESS),
	.DIA(16'h0000), .DIPA(2'b00), .WEA(1'b0),
	.DOA(INSTRUCTION[15:0]), .DOPA(INSTRUCTION[17:16]),
	.ENA(1'b1), .SSRA(1'b0),
	// port B: Load (write) port
	.CLKB(LOAD_CLK), .ADDRB(LOAD_ADDRESS), 
	.DIB(LOAD_INSTRUCTION[15:0]), .DIPB(LOAD_INSTRUCTION[17:16]), .WEB(LOAD_WE),
	.DOB(), .DOPB(),
	.ENB(1'b1), .SSRB(1'b0)
	);


endmodule
