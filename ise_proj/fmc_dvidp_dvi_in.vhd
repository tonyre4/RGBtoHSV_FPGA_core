------------------------------------------------------------------
--      _____
--     /     \
--    /____   \____
--   / \===\   \==/
--  /___\===\___\/  AVNET
--       \======/
--        \====/    
-----------------------------------------------------------------
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
-- Create Date:         Nov 11, 2009
-- Design Name:         FMC-DVIDP
-- Module Name:         fmc_dvidp_dvi_in.vhd
-- Project Name:        FMC-DVIDP
-- Target Devices:      Spartan-6
-- Avnet Boards:        FMC-DVIDP
--
-- Tool versions:       ISE 11.4
--
-- Description:         FMC-DVIDP DVI input interface.
--                      Based on VSK dvi_in.vhd and modified as follows:
--                      - rename dvi_in to fmc_dvidp_dvi_in
--                      - remove unused mode port
--                      - replace dvi_clk_p/dvi_clk_n by single-ended dvi_clk
--                      - add support for more devices via C_FAMILY generic:
--                         - spartan3adsp
--                         - spartan6
--
-- Dependencies:        
--
-- Revision:            Nov 11, 2009: 1.00 Initial version
--                      Dec 09, 2009: 1.01 Add a second set of regs
--
------------------------------------------------------------------


-- DISCLAIMER OF LIABILITY
-- 
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a 
-- license to use this text/file solely for design, simulation, 
-- implementation and creation of design files limited 
-- to Xilinx devices or technologies. Use with non-Xilinx 
-- devices or technologies is expressly prohibited and 
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information 
-- "as-is" solely for use in developing programs and 
-- solutions for Xilinx devices, with no obligation on the 
-- part of Xilinx to provide support. By providing this design, 
-- code, or information as one possible implementation of 
-- this feature, application or standard, Xilinx is making no 
-- representation that this implementation is free from any 
-- claims of infringement. You are responsible for 
-- obtaining any rights you may require for your implementation. 
-- Xilinx expressly disclaims any warranty whatsoever with 
-- respect to the adequacy of the implementation, including 
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied 
-- warranties of merchantability or fitness for a particular 
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are 
-- done at the user’s sole risk and will be unsupported.
--
--
-- Copyright (c) 2007, 2008 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part 
-- of this text at all times. 
--
------------------------------------------------------------------------------
-- Filename            : dvi_in.vhd
-- $Revision:: 2433   $: Revision of last commit
-- $Date:: 2008-05-27#$: Date of last commit
-- Description         : DVI Hardware Interface
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fmc_dvidp_dvi_in is
    Port ( clk     : in  STD_LOGIC;
           ce      : in  STD_LOGIC;
           de      : in  STD_LOGIC;
           vsync   : in  STD_LOGIC;
           hsync   : in  STD_LOGIC;
           red     : in  STD_LOGIC_VECTOR (7 downto 0);
           green   : in  STD_LOGIC_VECTOR (7 downto 0);
           blue    : in  STD_LOGIC_VECTOR (7 downto 0);
           de_o    : out  STD_LOGIC;
           vsync_o : out  STD_LOGIC;
           hsync_o : out  STD_LOGIC;
           red_o   : out  STD_LOGIC_VECTOR (7 downto 0);
           green_o : out  STD_LOGIC_VECTOR (7 downto 0);
           blue_o  : out  STD_LOGIC_VECTOR (7 downto 0)
    );
end fmc_dvidp_dvi_in;

architecture IMP of fmc_dvidp_dvi_in is

   signal de_r    : STD_LOGIC;
   signal vsync_r : STD_LOGIC;
   signal hsync_r : STD_LOGIC;
   signal red_r   : STD_LOGIC_VECTOR (7 downto 0);
   signal green_r : STD_LOGIC_VECTOR (7 downto 0);
   signal blue_r  : STD_LOGIC_VECTOR (7 downto 0);


begin

   In_Reg : process (clk)
   begin
      if Rising_Edge(clk) then
         de_r    <= de;
         vsync_r <= vsync;
         hsync_r <= hsync;
         red_r   <= red;
         green_r <= green;
         blue_r  <= blue;
      end if;
   end process;

   Out_Reg : process (clk)
   begin
      if Rising_Edge(clk) then
         de_o    <= de_r;
         vsync_o <= vsync_r;
         hsync_o <= hsync_r;
         red_o   <= red_r;
         green_o <= green_r;
         blue_o  <= blue_r;
      end if;
   end process;
         
end IMP;
