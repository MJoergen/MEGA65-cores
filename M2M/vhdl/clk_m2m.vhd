-------------------------------------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework  
--
-- Clock Generator using the Xilinx specific MMCME2_ADV:
--
--   QNICE expects 50 MHz
--   HyperRAM expects 100 MHz
--   Audio processing expects 30 MHz
--   HDMI 720p 50 Hz and 60 Hz expects 74.25 MHz (HDMI) and 371.25 MHz (TMDS)
--   HDMI 576p 50 Hz expects 27.00 MHz (HDMI) and 135.0 MHz (TMDS)
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
-------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

library xpm;
use xpm.vcomponents.all;

entity clk_m2m is
   port (
      sys_clk_i       : in  std_logic;   -- expects 100 MHz
      sys_rstn_i      : in  std_logic;   -- Asynchronous, asserted low
      core_rstn_i     : in  std_logic;   -- Reset only the core, asserted low

      qnice_clk_o     : out std_logic;   -- QNICE's 50 MHz main clock
      qnice_rst_o     : out std_logic;   -- QNICE's reset, synchronized

      hr_clk_x1_o     : out std_logic;   -- MEGA65 HyperRAM @ 100 MHz
      hr_clk_x2_o     : out std_logic;   -- MEGA65 HyperRAM @ 200 MHz
      hr_clk_x2_del_o : out std_logic;   -- MEGA65 HyperRAM @ 200 MHz phase delayed
      hr_rst_o        : out std_logic;   -- MEGA65 HyperRAM reset, synchronized

      hdmi_clk_sel_i  : in  std_logic;   -- 0: Choose 74.25 Mhz, 1: Choose 27.00 MHz
      tmds_clk_o      : out std_logic;   -- HDMI's 371.25 MHz pixelclock (74.25 MHz x 5) for TMDS
      hdmi_clk_o      : out std_logic;   -- HDMI's 74.25 MHz pixelclock for 720p @ 50 Hz
      hdmi_rst_o      : out std_logic;   -- HDMI's reset, synchronized

      audio_clk_o     : out std_logic;   -- Audio's 30 MHz clock
      audio_rst_o     : out std_logic;   -- Audio's reset, synchronized

      sys_pps_o       : out std_logic    -- One pulse per second (in sys_clk domain)
   );
end entity clk_m2m;

architecture rtl of clk_m2m is

signal qnice_fb_mmcm      : std_logic;
signal hdmi_720p_fb_mmcm  : std_logic;
signal hdmi_576p_fb_mmcm  : std_logic;
signal qnice_clk_mmcm     : std_logic;
signal hr_clk_x1_mmcm     : std_logic;
signal hr_clk_x2_mmcm     : std_logic;
signal hr_clk_x2_del_mmcm : std_logic;
signal audio_clk_mmcm     : std_logic;
signal tmds_720p_clk_mmcm : std_logic;
signal hdmi_720p_clk_mmcm : std_logic;
signal tmds_576p_clk_mmcm : std_logic;
signal hdmi_576p_clk_mmcm : std_logic;

signal sys_clk_9975_bg    : std_logic;

signal qnice_locked       : std_logic;
signal hdmi_720p_locked   : std_logic;
signal hdmi_576p_locked   : std_logic;

signal sys_counter        : natural range 0 to 99_999_999;

begin

   -------------------------------------------------------------------------------------
   -- Generate QNICE and HyperRAM clock
   -------------------------------------------------------------------------------------

   -- VCO frequency range for Artix 7 speed grade -1 : 600 MHz - 1200 MHz
   -- f_VCO = f_CLKIN * CLKFBOUT_MULT_F / DIVCLK_DIVIDE
   
   i_clk_qnice : PLLE2_BASE
      generic map (
         BANDWIDTH            => "OPTIMIZED",
         CLKFBOUT_MULT        => 12,         -- 1200 MHz
         CLKFBOUT_PHASE       => 0.000,
         CLKIN1_PERIOD        => 10.0,       -- INPUT @ 100 MHz
         CLKOUT0_DIVIDE       => 24,         -- QNICE @ 50 MHz
         CLKOUT0_DUTY_CYCLE   => 0.500,
         CLKOUT0_PHASE        => 0.000,
         CLKOUT1_DIVIDE       => 12,         -- HyperRAM @ 100 MHz
         CLKOUT1_DUTY_CYCLE   => 0.500,
         CLKOUT1_PHASE        => 0.000,
         CLKOUT2_DIVIDE       => 6,          -- HyperRAM @ 200 MHz
         CLKOUT2_DUTY_CYCLE   => 0.500,
         CLKOUT2_PHASE        => 0.000,
         CLKOUT3_DIVIDE       => 6,          -- HyperRAM @ 200 MHz phase delayed
         CLKOUT3_DUTY_CYCLE   => 0.500,
         CLKOUT3_PHASE        => 180.000,
         CLKOUT4_DIVIDE       => 40,         -- Audio @ 30 MHz
         CLKOUT4_DUTY_CYCLE   => 0.500,
         CLKOUT4_PHASE        => 0.000,
         DIVCLK_DIVIDE        => 1,
         REF_JITTER1          => 0.010,
         STARTUP_WAIT         => "FALSE"
      )
      port map (
         CLKFBIN             => qnice_fb_mmcm,
         CLKFBOUT            => qnice_fb_mmcm,
         CLKIN1              => sys_clk_i,
         CLKOUT0             => qnice_clk_mmcm,
         CLKOUT1             => hr_clk_x1_mmcm,
         CLKOUT2             => hr_clk_x2_mmcm,
         CLKOUT3             => hr_clk_x2_del_mmcm,
         CLKOUT4             => audio_clk_mmcm,
         LOCKED              => qnice_locked,
         PWRDWN              => '0',
         RST                 => '0'
      ); -- i_clk_qnice

   ---------------------------------------------------------------------------------------
   -- Generate 74.25 MHz for 720p (50 Hz or 60 Hz) and 5x74.25 MHz = 371.25 MHz for TMDS
   ---------------------------------------------------------------------------------------

   i_clk_hdmi_720p : MMCME2_BASE
      generic map (
         BANDWIDTH            => "OPTIMIZED",
         CLKFBOUT_MULT_F      => 37.125,     -- f_VCO = (100 MHz / 5) x 37.125 = 742.5 MHz
         CLKFBOUT_PHASE       => 0.000,
         CLKIN1_PERIOD        => 10.0,       -- INPUT @ 100 MHz
         CLKOUT0_DIVIDE_F     => 2.000,      -- TMDS @ 371.25 MHz
         CLKOUT0_DUTY_CYCLE   => 0.500,
         CLKOUT0_PHASE        => 0.000,
         CLKOUT1_DIVIDE       => 10,         -- HDMI @ 74.25 MHz
         CLKOUT1_DUTY_CYCLE   => 0.500,
         CLKOUT1_PHASE        => 0.000,
         DIVCLK_DIVIDE        => 5,
         REF_JITTER1          => 0.010,
         STARTUP_WAIT         => FALSE
      )
      port map (
         CLKFBIN             => hdmi_720p_fb_mmcm,
         CLKFBOUT            => hdmi_720p_fb_mmcm,
         CLKIN1              => sys_clk_i,
         CLKOUT0             => tmds_720p_clk_mmcm,
         CLKOUT1             => hdmi_720p_clk_mmcm,
         LOCKED              => hdmi_720p_locked,
         PWRDWN              => '0',
         RST                 => '0'
      ); -- i_clk_hdmi_720p

   ---------------------------------------------------------------------------------------
   -- Generate 27.00 MHz for 576p @ 50 Hz and 5x27.00 MHz = 135.0 MHz for TMDS
   ---------------------------------------------------------------------------------------

   i_clk_hdmi_576p : MMCME2_BASE
      generic map (
         BANDWIDTH            => "OPTIMIZED",
         CLKFBOUT_MULT_F      => 47.250,     -- f_VCO = (100 MHz / 5) x 47.250 = 945 MHz
         CLKFBOUT_PHASE       => 0.000,
         CLKIN1_PERIOD        => 10.0,       -- INPUT @ 100 MHz
         CLKOUT0_DIVIDE_F     => 7.000,      -- TMDS @ 135.0 MHz
         CLKOUT0_DUTY_CYCLE   => 0.500,
         CLKOUT0_PHASE        => 0.000,
         CLKOUT1_DIVIDE       => 35,         -- HDMI @ 27.00 MHz
         CLKOUT1_DUTY_CYCLE   => 0.500,
         CLKOUT1_PHASE        => 0.000,
         DIVCLK_DIVIDE        => 5,
         REF_JITTER1          => 0.010,
         STARTUP_WAIT         => FALSE
      )
      port map (
         CLKFBIN             => hdmi_576p_fb_mmcm,
         CLKFBOUT            => hdmi_576p_fb_mmcm,
         CLKIN1              => sys_clk_i,
         CLKOUT0             => tmds_576p_clk_mmcm,
         CLKOUT1             => hdmi_576p_clk_mmcm,
         LOCKED              => hdmi_576p_locked,
         PWRDWN              => '0',
         RST                 => '0'
      ); -- i_clk_hdmi_576p

   ---------------------------------------------------------------------------------------
   -- Output buffering
   ---------------------------------------------------------------------------------------

   qnice_clk_bufg : BUFG
      port map (
         I => qnice_clk_mmcm,
         O => qnice_clk_o
      );

   hr_clk_x1_bufg : BUFG
      port map (
         I => hr_clk_x1_mmcm,
         O => hr_clk_x1_o
      );

   hr_clk_x2_bufg : BUFG
      port map (
         I => hr_clk_x2_mmcm,
         O => hr_clk_x2_o
      );

   hr_clk_x2_del_bufg : BUFG
      port map (
         I => hr_clk_x2_del_mmcm,
         O => hr_clk_x2_del_o
      );

   audio_clk_bufg : BUFG
      port map (
         I => audio_clk_mmcm,
         O => audio_clk_o
      );

   tmds_clk_bufgmux : BUFGMUX_CTRL
      port map (
         S  => hdmi_clk_sel_i,
         I0 => tmds_720p_clk_mmcm,
         I1 => tmds_576p_clk_mmcm,
         O  => tmds_clk_o
      );

   hdmi_clk_bufgmux : BUFGMUX_CTRL
      port map (
         S  => hdmi_clk_sel_i,
         I0 => hdmi_720p_clk_mmcm,
         I1 => hdmi_576p_clk_mmcm,
         O  => hdmi_clk_o
      );

   -------------------------------------
   -- Reset generation
   -------------------------------------

   i_xpm_cdc_async_rst_qnice : xpm_cdc_async_rst
      generic map (
         RST_ACTIVE_HIGH => 1
      )
      port map (
         src_arst  => not (qnice_locked and sys_rstn_i),   -- 1-bit input: Source reset signal.
         dest_clk  => qnice_clk_o,      -- 1-bit input: Destination clock.
         dest_arst => qnice_rst_o       -- 1-bit output: src_rst synchronized to the destination clock domain.
                                        -- This output is registered.
      );

   i_xpm_cdc_async_rst_hr : xpm_cdc_async_rst
      generic map (
         RST_ACTIVE_HIGH => 1,
         DEST_SYNC_FF    => 10
      )
      port map (
         -- 1-bit input: Source reset signal
         -- Important: The HyperRAM needs to be reset when ascal is being reset! The Avalon memory interface
         -- assumes that both ends maintain state information and agree on this state information. Therefore,
         -- one side can not be reset in the middle of e.g. a burst transaction, without the other end becoming confused.
         src_arst  => not (qnice_locked and sys_rstn_i and core_rstn_i) or hdmi_rst_o,
         dest_clk  => hr_clk_x1_o,      -- 1-bit input: Destination clock.
         dest_arst => hr_rst_o          -- 1-bit output: src_rst synchronized to the destination clock domain.
                                        -- This output is registered.
      );

   i_xpm_cdc_async_rst_audio : xpm_cdc_async_rst
      generic map (
         RST_ACTIVE_HIGH => 1,
         DEST_SYNC_FF    => 10
      )
      port map (
         src_arst  => not (qnice_locked and sys_rstn_i),   -- 1-bit input: Source reset signal.
         dest_clk  => audio_clk_o,      -- 1-bit input: Destination clock.
         dest_arst => audio_rst_o       -- 1-bit output: src_rst synchronized to the destination clock domain.
                                        -- This output is registered.
      );

   i_xpm_cdc_async_rst_hdmi : xpm_cdc_async_rst
      generic map (
         RST_ACTIVE_HIGH => 1,
         DEST_SYNC_FF    => 10
      )
      port map (
         src_arst  => not (hdmi_720p_locked and hdmi_576p_locked and sys_rstn_i),   -- 1-bit input: Source reset signal.
         dest_clk  => hdmi_clk_o,       -- 1-bit input: Destination clock.
         dest_arst => hdmi_rst_o        -- 1-bit output: src_rst synchronized to the destination clock domain.
                                        -- This output is registered.
      );

   p_sys_pps : process (sys_clk_i)
   begin
      if rising_edge(sys_clk_i) then
         if sys_counter < 99_999_999 then
            sys_counter <= sys_counter + 1;
            sys_pps_o   <= '0';
         else
            sys_counter <= 0;
            sys_pps_o   <= '1';
         end if;
      end if;
   end process p_sys_pps;

end architecture rtl;

