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
-- Create Date:         Jan 20, 2010
-- Design Name:         FMC-DVIDP DVI Passthrough Demo
-- Module Name:         fmc_dvidp_dvi_passthrough.vhd
-- Project Name:        FMC-DVIDP
-- Target Devices:      Spartan-6
-- Avnet Boards:        FMC-DVIDP
--
-- Tool versions:       ISE 11.4
--
-- Description:         FMC-DVIDP DVI Passthrough Demo.
--
-- Dependencies:        
--
-- Revision:            Jan 20, 2010: 1.00 Initial version
--
------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity fmc_dvidp_dvi_passthrough_demo is
  port (
--  reset                    : in  std_logic;
    clk_100mhz               : in  std_logic;
	 switch             		  : in std_logic_vector(7 downto 0);
	 led                      : out std_logic_vector(7 downto 0);
    -- Push-buttons
    push_buttons             : in std_logic_vector(3 downto 0);
    -- FMC-DVI/DP : DVI Input Interface
    fmc_dvidp_dvii_clk       : in  std_logic;
    fmc_dvidp_dvii_de        : in  std_logic;
    fmc_dvidp_dvii_vsync     : in  std_logic;
    fmc_dvidp_dvii_hsync     : in  std_logic;
    fmc_dvidp_dvii_red       : in  std_logic_vector(7 downto 0);
    fmc_dvidp_dvii_green     : in  std_logic_vector(7 downto 0);
    fmc_dvidp_dvii_blue      : in  std_logic_vector(7 downto 0);
    -- FMC-DVI/DP : DVI Output Interface
    fmc_dvidp_dvio_reset_n   : out std_logic;
    fmc_dvidp_dvio_clk       : out std_logic;
    fmc_dvidp_dvio_de        : out std_logic;
    fmc_dvidp_dvio_vsync     : out std_logic;
    fmc_dvidp_dvio_hsync     : out std_logic;
    fmc_dvidp_dvio_data      : out std_logic_vector(11 downto 0);
    -- FMC-DVI/DP : I2C Controller
    fmc_dvidp_i2c_scl        : out std_logic;
    fmc_dvidp_i2c_sda        : inout std_logic;
    fmc_dvidp_i2c_rst        : out std_logic;
    -- FMC-DVI/DP : Test Points
    fmc_dvidp_tp1            : out std_logic;
    fmc_dvidp_tp2            : out std_logic;
    fmc_dvidp_tp3            : out std_logic
    );
end fmc_dvidp_dvi_passthrough_demo;

architecture IMP of fmc_dvidp_dvi_passthrough_demo is

  signal net1       : std_logic;
  signal net0_8     : std_logic_vector(7 downto 0);

  signal sys_clk    : std_logic;
  signal sys_clk_dv : std_logic;
  
  signal reset      : std_logic;

  --
  -- Picoblaze-based I2C Controller
  --

  signal pb_clk     : std_logic;

  component FMC_DVIDP_CONFIG
    port
    (
      CLK           : in  std_logic;
      DIPSW_IN      : in  std_logic_vector(7 downto 0);
      PUSHB_IN      : in  std_logic_vector(3 downto 0);
      RESET_OUT     : out std_logic;
      SCL_OUT       : out std_logic;
      SDA_OUT       : out std_logic;
      SDA_IN        : in std_logic
    );   
  end component;

  signal pb_reset_out:std_logic;
  signal scl_out    : std_logic;
  signal sda_out    : std_logic;
  signal sda_en_n   : std_logic;
  signal sda_in     : std_logic;

  --
  -- FMC-DVI/DP : DVI Input Interface
  -- 

  component fmc_dvidp_dvi_in
    port
    (
      clk           : in  std_logic;
      ce            : in  std_logic;
      de            : in  std_logic;
      vsync         : in  std_logic;
      hsync         : in  std_logic;
      red           : in  std_logic_vector(7 downto 0);
      green         : in  std_logic_vector(7 downto 0);
      blue          : in  std_logic_vector(7 downto 0);
      de_o          : out std_logic;
      vsync_o       : out std_logic;
      hsync_o       : out std_logic;
      red_o         : out std_logic_vector(7 downto 0);
      green_o       : out std_logic_vector(7 downto 0);
      blue_o        : out std_logic_vector(7 downto 0)
    );
  end component;

  signal video_clk  : std_logic;

  --
  -- DVI Passthrough   {INSERT YOUR CODE HERE}
  -- 

  signal dvii_de    : std_logic;
  signal dvii_vsync : std_logic;
  signal dvii_hsync : std_logic;
  signal dvii_red   : std_logic_vector(7 downto 0);
  signal dvii_green : std_logic_vector(7 downto 0);
  signal dvii_blue  : std_logic_vector(7 downto 0);

  signal dvio_de    : std_logic;
  signal dvio_vsync : std_logic;
  signal dvio_hsync : std_logic;
  signal dvio_red   : std_logic_vector(7 downto 0);
  signal dvio_green : std_logic_vector(7 downto 0);
  signal dvio_blue  : std_logic_vector(7 downto 0);

  --
  -- FMC-DVI/DP : DVI Output Interface
  -- 
 

  component fmc_dvidp_dvi_out
    generic
    (
      C_FAMILY : string := "spartan6" 
    );
    port
    (
      clk           : in  std_logic;
      reset         : in  std_logic;
      ce            : in  std_logic;
      oe            : in  std_logic;
      de_i          : in  std_logic;
      vsync_i       : in  std_logic;
      hsync_i       : in  std_logic;
      red_i         : in  std_logic_vector(7 downto 0);
      green_i       : in  std_logic_vector(7 downto 0);
      blue_i        : in  std_logic_vector(7 downto 0);
      dvi_de        : out std_logic;
      dvi_vsync     : out std_logic;
      dvi_hsync     : out std_logic;
      dvi_data      : out std_logic_vector(11 downto 0);
      dvi_clk       : out std_logic;
      dvi_reset_n   : out std_logic;
      debug         : out std_logic_vector(28 downto 0)
     );
  end component;

	signal R,G,B : std_logic_vector(fmc_dvidp_dvii_red'length-1 downto 0);
	signal Ro,Go,Bo : std_logic_vector(fmc_dvidp_dvii_red'length-1 downto 0);
	signal H,S,V : unsigned(fmc_dvidp_dvii_red'length-1 downto 0);

begin

  net1   <= '1';
  net0_8 <= "00000000";

  sys_clk_l : IBUF
    port map 
    (
      I             => clk_100mhz,
      O             => sys_clk
    );

--  sys_clk_dv_l : BUFIO2
--    generic map
--    (
--      DIVIDE_BYPASS => TRUE,
--      DIVIDE        => 2
--    )
--    port map
--    (
--      I             => sys_clk,
--      DIVCLK        => sys_clk_dv,
--      SERDESSTROBE  => open,
--      IOCLK         => open
--    );
-- Solucion NUEVA (3/DIC/2018):
-- https://forums.xilinx.com/t5/Spartan-Family-FPGAs/Spartan-6-DCM-SP-dropping-quot-LOCKED-quot-signal/td-p/411927


DCM_SP_inst : DCM_SP
   generic map (
      CLKDV_DIVIDE => 2.0,                   -- CLKDV divide value
                                             -- (1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,9,10,11,12,13,14,15,16).
      CLKFX_DIVIDE => 1,                     -- Divide value on CLKFX outputs - D - (1-32)
      CLKFX_MULTIPLY => 2,                   -- Multiply value on CLKFX outputs - M - (2-32)
      CLKIN_DIVIDE_BY_2 => FALSE,            -- CLKIN divide by two (TRUE/FALSE)
      CLKIN_PERIOD => 20.0,                  -- Input clock period specified in nS
      CLKOUT_PHASE_SHIFT => "NONE",          -- Output phase shift (NONE, FIXED, VARIABLE)
      CLK_FEEDBACK => "1X",                  -- Feedback source (NONE, 1X, 2X)
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- SYSTEM_SYNCHRNOUS or SOURCE_SYNCHRONOUS
      DFS_FREQUENCY_MODE => "LOW",           -- Unsupported - Do not change value
      DLL_FREQUENCY_MODE => "LOW",           -- Unsupported - Do not change value
      DSS_MODE => "NONE",                    -- Unsupported - Do not change value
      DUTY_CYCLE_CORRECTION => TRUE,         -- Unsupported - Do not change value
      FACTORY_JF => X"c080",                 -- Unsupported - Do not change value
      PHASE_SHIFT => 0,                      -- Amount of fixed phase shift (-255 to 255)
      STARTUP_WAIT => FALSE                  -- Delay config DONE until DCM_SP LOCKED (TRUE/FALSE)
   )
   port map (
      CLK0 => OPEN,         -- 1-bit output: 0 degree clock output
      CLK180 => OPEN,     -- 1-bit output: 180 degree clock output
      CLK270 => OPEN,     -- 1-bit output: 270 degree clock output
      CLK2X => OPEN,       -- 1-bit output: 2X clock frequency clock output
      CLK2X180 => OPEN, -- 1-bit output: 2X clock frequency, 180 degree clock output
      CLK90 => OPEN,       -- 1-bit output: 90 degree clock output
      CLKDV => sys_clk_dv,       -- 1-bit output: Divided clock output
      CLKFX => OPEN,       -- 1-bit output: Digital Frequency Synthesizer output (DFS)
      CLKFX180 => OPEN, -- 1-bit output: 180 degree CLKFX output
      LOCKED => OPEN,     -- 1-bit output: DCM_SP Lock Output
      PSDONE => OPEN,     -- 1-bit output: Phase shift done output
      STATUS => OPEN,     -- 8-bit output: DCM_SP status output
      CLKFB => OPEN,       -- 1-bit input: Clock feedback input
      CLKIN => SYS_CLK,       -- 1-bit input: Clock input
      DSSEN => '0',       -- 1-bit input: Unsupported, specify to GND.
      PSCLK => '0',       -- 1-bit input: Phase shift clock input
      PSEN => '0',         -- 1-bit input: Phase shift enable
      PSINCDEC => '0', -- 1-bit input: Phase shift increment/decrement input
      RST => '0'            -- 1-bit input: Active high reset input
   );

  reset <= push_buttons(0);
  
  --
  -- Picoblaze-based I2C Controller
  --

  pb_clk_l : BUFG
    port map 
    (
      I             => sys_clk_dv,
      O             => pb_clk
    );


  fmc_dvidp_config_l : FMC_DVIDP_CONFIG
    port map (
      CLK           => pb_clk,
      DIPSW_IN      => net0_8,
      PUSHB_IN      => push_buttons,
      RESET_OUT     => pb_reset_out,
      SCL_OUT       => scl_out,
      SDA_OUT       => sda_en_n,
      SDA_IN        => sda_in
      );

  i2c_scl_obuf : OBUF
    port map 
    (
      O             => fmc_dvidp_i2c_scl,
      I             => scl_out
    );

  sda_out           <= '0';
  
  i2c_sda_iobuf : IOBUF
    port map
    (
      IO            => fmc_dvidp_i2c_sda,
      I             => sda_out,
      T             => sda_en_n,
      O             => sda_in
    );
    
  fmc_dvidp_i2c_rst <= not pb_reset_out;    

  --
  -- FMC-DVI/DP : DVI Input Interface
  -- 

  video_clk_l : IBUFG
    port map 
    (
      I             => fmc_dvidp_dvii_clk,
      O             => video_clk
    );

  fmc_dvidp_dvi_in_l : fmc_dvidp_dvi_in
    port map
    (
      clk           => video_clk,
      ce            => net1,
      de            => fmc_dvidp_dvii_de,
      vsync         => fmc_dvidp_dvii_vsync,
      hsync         => fmc_dvidp_dvii_hsync,
      red           => fmc_dvidp_dvii_red,
      green         => fmc_dvidp_dvii_green,
      blue          => fmc_dvidp_dvii_blue,
      de_o          => dvii_de,
      vsync_o       => dvii_vsync,
      hsync_o       => dvii_hsync,
      red_o         => dvii_red,
      green_o       => dvii_green,
      blue_o        => dvii_blue 
    );

  --
  -- DVI Passthrough   {INSERT YOUR CODE HERE}
  -- 
--//////////////////////////////////////////////////////////////////////////////////////////////////////
	R <= fmc_dvidp_dvii_red;
	G <= fmc_dvidp_dvii_green;
	B <= fmc_dvidp_dvii_blue;

	cconv: entity work.RGBtoHSV (simplest) port map(R,G,B,H,S,V);

	led <= switch;
	
	vMux: entity work.videoMux (vM) port map(
			  mode => switch(3 downto 0),
			  RGB (23 downto 16) => std_logic_vector(R),
			  RGB (15 downto  8) => std_logic_vector(G),
			  RGB ( 7 downto  0) => std_logic_vector(B),
			  HSV (23 downto 16) => std_logic_vector(H),
			  HSV (15 downto  8) => std_logic_vector(S),
			  HSV ( 7 downto  0) => std_logic_vector(V),
           Gray => "00000000",
           C1R => Ro,
           C2G => Go,
           C3B => Bo
	);

	--Ro <= std_logic_vector(H);
	--Go <= std_logic_vector(S);
	--Bo <= std_logic_vector(V);

--Salida procesada
  dvio_de           <= dvii_de;
  dvio_vsync        <= dvii_vsync;
  dvio_hsync        <= dvii_hsync;
--  dvio_red          <= dvii_red;
--  dvio_green        <= dvii_green;
--  dvio_blue         <= dvii_blue;
  dvio_red          <= Ro;
  dvio_green        <= Go;
  dvio_blue         <= Bo;
  
--////////////////////////////////////////////////////////////////////////////////////////////////////////


  --
  -- FMC-DVI/DP : DVI Output Interface
  -- 

  fmc_dvidp_dvi_out_l : fmc_dvidp_dvi_out
    generic map
    (
      C_FAMILY      => "spartan6"
    )
    port map
    (
      clk           => video_clk,
      reset         => reset,
      ce            => net1,
      oe            => net1,
      de_i          => dvio_de,
      vsync_i       => dvio_vsync,
      hsync_i       => dvio_hsync,
      red_i         => dvio_red,
      green_i       => dvio_green,
      blue_i        => dvio_blue,
      dvi_de        => fmc_dvidp_dvio_de,
      dvi_vsync     => fmc_dvidp_dvio_vsync,
      dvi_hsync     => fmc_dvidp_dvio_hsync,
      dvi_data      => fmc_dvidp_dvio_data,
      dvi_clk       => fmc_dvidp_dvio_clk,
      dvi_reset_n   => fmc_dvidp_dvio_reset_n,
      debug         => open
     );
     
   --
   -- FMC-DVI/DP : Test Points
   --   
   
   fmc_dvidp_tp1    <= '0';
   fmc_dvidp_tp2    <= '0';
   fmc_dvidp_tp3    <= '0';
   
         
end IMP;
