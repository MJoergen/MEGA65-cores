-------------------------------------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework
--
-- Clock Generator using the Xilinx specific MMCME2_ADV:
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
-------------------------------------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;

library unisim;
   use unisim.vcomponents.all;

library xpm;
   use xpm.vcomponents.all;

entity clk is
   port (
      sys_clk_i   : in    std_logic; -- expects 100 MHz

      video_clk_o : out   std_logic;
      video_rst_o : out   std_logic;
      main_clk_o  : out   std_logic;
      main_rst_o  : out   std_logic
   );
end entity clk;

architecture rtl of clk is

   signal main_fb        : std_logic;
   signal main_clk_mmcm  : std_logic;
   signal main_locked    : std_logic;
   signal video_fb       : std_logic;
   signal video_clk_mmcm : std_logic;
   signal video_locked   : std_logic;

begin

   -------------------------------------------------------------------------------------
   -- Generate QNICE and HyperRAM clock
   -------------------------------------------------------------------------------------

   clk_main_inst : component mmcme2_adv
      generic map (
         BANDWIDTH            => "OPTIMIZED",
         CLKOUT4_CASCADE      => FALSE,
         COMPENSATION         => "ZHOLD",
         STARTUP_WAIT         => FALSE,
         CLKIN1_PERIOD        => 10.0,   -- INPUT @ 100 MHz
         REF_JITTER1          => 0.010,
         DIVCLK_DIVIDE        => 1,
         CLKFBOUT_MULT_F      => 10.0,
         CLKFBOUT_PHASE       => 0.000,
         CLKFBOUT_USE_FINE_PS => FALSE,
         CLKOUT0_DIVIDE_F     => 8.000, -- 125 MHz
         CLKOUT0_PHASE        => 0.000,
         CLKOUT0_DUTY_CYCLE   => 0.500,
         CLKOUT0_USE_FINE_PS  => FALSE
      )
      port map (
         -- Output clocks
         clkfbout     => main_fb,
         clkout0      => main_clk_mmcm,
         -- Input clock control
         clkfbin      => main_fb,
         clkin1       => sys_clk_i,
         clkin2       => '0',
         -- Tied to always select the primary input clock
         clkinsel     => '1',
         -- Ports for dynamic reconfiguration
         daddr        => (others => '0'),
         dclk         => '0',
         den          => '0',
         di           => (others => '0'),
         do           => open,
         drdy         => open,
         dwe          => '0',
         -- Ports for dynamic phase shift
         psclk        => '0',
         psen         => '0',
         psincdec     => '0',
         psdone       => open,
         -- Other control and status signals
         locked       => main_locked,
         clkinstopped => open,
         clkfbstopped => open,
         pwrdwn       => '0',
         rst          => '0'
      ); -- clk_main_inst

   clk_video_inst : component mmcme2_adv
      generic map (
         BANDWIDTH            => "OPTIMIZED",
         CLKOUT4_CASCADE      => FALSE,
         COMPENSATION         => "ZHOLD",
         STARTUP_WAIT         => FALSE,
         CLKIN1_PERIOD        => 10.0,   -- INPUT @ 100 MHz
         REF_JITTER1          => 0.010,
         DIVCLK_DIVIDE        => 4,
         CLKFBOUT_MULT_F      => 37.125,
         CLKFBOUT_PHASE       => 0.000,
         CLKFBOUT_USE_FINE_PS => FALSE,
         CLKOUT0_DIVIDE_F     => 12.500, -- 74.25 MHz
         CLKOUT0_PHASE        => 0.000,
         CLKOUT0_DUTY_CYCLE   => 0.500,
         CLKOUT0_USE_FINE_PS  => FALSE
      )
      port map (
         -- Output clocks
         clkfbout     => video_fb,
         clkout0      => video_clk_mmcm,
         -- Input clock control
         clkfbin      => video_fb,
         clkin1       => sys_clk_i,
         clkin2       => '0',
         -- Tied to always select the primary input clock
         clkinsel     => '1',
         -- Ports for dynamic reconfiguration
         daddr        => (others => '0'),
         dclk         => '0',
         den          => '0',
         di           => (others => '0'),
         do           => open,
         drdy         => open,
         dwe          => '0',
         -- Ports for dynamic phase shift
         psclk        => '0',
         psen         => '0',
         psincdec     => '0',
         psdone       => open,
         -- Other control and status signals
         locked       => video_locked,
         clkinstopped => open,
         clkfbstopped => open,
         pwrdwn       => '0',
         rst          => '0'
      ); -- clk_video_inst


   -------------------------------------------------------------------------------------
   -- Output buffering
   -------------------------------------------------------------------------------------

   main_clk_bufg_inst : component bufg
      port map (
         i => main_clk_mmcm,
         o => main_clk_o
      ); -- main_clk_bufg_inst

   video_clk_bufg_inst : component bufg
      port map (
         i => video_clk_mmcm,
         o => video_clk_o
      ); -- video_clk_bufg_inst


   -------------------------------------
   -- Reset generation
   -------------------------------------

   xpm_cdc_async_rst_main_inst : component xpm_cdc_async_rst
      generic map (
         RST_ACTIVE_HIGH => 1,
         DEST_SYNC_FF    => 6
      )
      port map (
         src_arst  => not main_locked,
         dest_clk  => main_clk_o,
         dest_arst => main_rst_o
      ); -- xpm_cdc_async_rst_main_inst

   xpm_cdc_async_rst_video_inst : component xpm_cdc_async_rst
      generic map (
         RST_ACTIVE_HIGH => 1,
         DEST_SYNC_FF    => 6
      )
      port map (
         src_arst  => not video_locked,
         dest_clk  => video_clk_o,
         dest_arst => video_rst_o
      ); -- xpm_cdc_async_rst_video_inst

end architecture rtl;

