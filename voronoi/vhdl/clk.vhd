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

      video_clk_o : out   std_logic; -- video's 25.2 MHz clock
      video_rst_o : out   std_logic  -- video's reset, synchronized, active high
   );
end entity clk;

architecture rtl of clk is

   signal clk_fb         : std_logic;
   signal video_clk_mmcm : std_logic;
   signal video_locked   : std_logic;

begin

   -------------------------------------------------------------------------------------
   -- Generate QNICE and HyperRAM clock
   -------------------------------------------------------------------------------------

   clk_video_inst : component mmcme2_adv
      generic map (
         BANDWIDTH            => "OPTIMIZED",
         CLKOUT4_CASCADE      => FALSE,
         COMPENSATION         => "ZHOLD",
         STARTUP_WAIT         => FALSE,
         CLKIN1_PERIOD        => 10.0,   -- INPUT @ 100 MHz
         REF_JITTER1          => 0.010,
         DIVCLK_DIVIDE        => 5,
         CLKFBOUT_MULT_F      => 47.250,
         CLKFBOUT_PHASE       => 0.000,
         CLKFBOUT_USE_FINE_PS => FALSE,
         CLKOUT0_DIVIDE_F     => 37.500, -- 25.200 MHz
         CLKOUT0_PHASE        => 0.000,
         CLKOUT0_DUTY_CYCLE   => 0.500,
         CLKOUT0_USE_FINE_PS  => FALSE
      )
      port map (
         -- Output clocks
         clkfbout     => clk_fb,
         clkout0      => video_clk_mmcm,
         -- Input clock control
         clkfbin      => clk_fb,
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

   video_clk_bufg_inst : component bufg
      port map (
         i => video_clk_mmcm,
         o => video_clk_o
      ); -- video_clk_bufg_inst

   -------------------------------------
   -- Reset generation
   -------------------------------------

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
