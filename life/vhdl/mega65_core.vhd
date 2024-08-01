----------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework
--
-- MEGA65 main file that contains the whole machine
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
----------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

library xpm;
   use xpm.vcomponents.all;

library work;
   use work.video_modes_pkg.all;
   use work.globals.all;

entity mega65_core is
   generic (
      G_FONT_PATH     : string  := "";
      G_UART_BAUDRATE : natural := 115_200;
      G_COLS          : integer := 60;
      G_ROWS          : integer := 40;
      G_BOARD         : string -- Which platform are we running on.
   );
   port (
      --------------------------------------------------------------------------------------------------------
      -- QNICE Clock Domain
      --------------------------------------------------------------------------------------------------------

      -- Get QNICE clock from the framework: for the vdrives as well as for RAMs and ROMs
      qnice_clk_i             : in    std_logic;
      qnice_rst_i             : in    std_logic;

      -- Video and audio mode control
      qnice_dvi_o             : out   std_logic;             -- 0=HDMI (with sound), 1=DVI (no sound)
      qnice_video_mode_o      : out   video_mode_type;       -- Defined in video_modes_pkg.vhd
      qnice_osm_cfg_scaling_o : out   std_logic_vector(8 downto 0);
      qnice_scandoubler_o     : out   std_logic;             -- 0 = no scandoubler, 1 = scandoubler
      qnice_audio_mute_o      : out   std_logic;
      qnice_audio_filter_o    : out   std_logic;
      qnice_zoom_crop_o       : out   std_logic;
      qnice_ascal_mode_o      : out   std_logic_vector(1 downto 0);
      qnice_ascal_polyphase_o : out   std_logic;
      qnice_ascal_triplebuf_o : out   std_logic;
      qnice_retro15khz_o      : out   std_logic;             -- 0 = normal frequency, 1 = retro 15 kHz frequency
      qnice_csync_o           : out   std_logic;             -- 0 = normal HS/VS, 1 = Composite Sync

      -- Flip joystick ports
      qnice_flip_joyports_o   : out   std_logic;

      -- On-Screen-Menu selections
      qnice_osm_control_i     : in    std_logic_vector(255 downto 0);

      -- QNICE general purpose register
      qnice_gp_reg_i          : in    std_logic_vector(255 downto 0);

      -- Core-specific devices
      qnice_dev_id_i          : in    std_logic_vector(15 downto 0);
      qnice_dev_addr_i        : in    std_logic_vector(27 downto 0);
      qnice_dev_data_i        : in    std_logic_vector(15 downto 0);
      qnice_dev_data_o        : out   std_logic_vector(15 downto 0);
      qnice_dev_ce_i          : in    std_logic;
      qnice_dev_we_i          : in    std_logic;
      qnice_dev_wait_o        : out   std_logic;

      --------------------------------------------------------------------------------------------------------
      -- HyperRAM Clock Domain
      --------------------------------------------------------------------------------------------------------

      hr_clk_i                : in    std_logic;
      hr_rst_i                : in    std_logic;
      hr_core_write_o         : out   std_logic;
      hr_core_read_o          : out   std_logic;
      hr_core_address_o       : out   std_logic_vector(31 downto 0);
      hr_core_writedata_o     : out   std_logic_vector(15 downto 0);
      hr_core_byteenable_o    : out   std_logic_vector( 1 downto 0);
      hr_core_burstcount_o    : out   std_logic_vector( 7 downto 0);
      hr_core_readdata_i      : in    std_logic_vector(15 downto 0);
      hr_core_readdatavalid_i : in    std_logic;
      hr_core_waitrequest_i   : in    std_logic;
      hr_high_i               : in    std_logic;             -- Core is too fast
      hr_low_i                : in    std_logic;             -- Core is too slow

      --------------------------------------------------------------------------------------------------------
      -- Video Clock Domain
      --------------------------------------------------------------------------------------------------------

      video_clk_o             : out   std_logic;
      video_rst_o             : out   std_logic;
      video_ce_o              : out   std_logic;
      video_ce_ovl_o          : out   std_logic;
      video_red_o             : out   std_logic_vector(7 downto 0);
      video_green_o           : out   std_logic_vector(7 downto 0);
      video_blue_o            : out   std_logic_vector(7 downto 0);
      video_vs_o              : out   std_logic;
      video_hs_o              : out   std_logic;
      video_hblank_o          : out   std_logic;
      video_vblank_o          : out   std_logic;

      --------------------------------------------------------------------------------------------------------
      -- Core Clock Domain
      --------------------------------------------------------------------------------------------------------

      clk_i                   : in    std_logic;             -- 100 MHz clock

      -- Share clock and reset with the framework
      main_clk_o              : out   std_logic;             -- CORE's clock
      main_rst_o              : out   std_logic;             -- CORE's reset, synchronized

      -- M2M's reset manager provides 2 signals:
      --    m2m:   Reset the whole machine: Core and Framework
      --    core:  Only reset the core
      main_reset_m2m_i        : in    std_logic;
      main_reset_core_i       : in    std_logic;

      main_pause_core_i       : in    std_logic;

      -- On-Screen-Menu selections
      main_osm_control_i      : in    std_logic_vector(255 downto 0);

      -- QNICE general purpose register converted to main clock domain
      main_qnice_gp_reg_i     : in    std_logic_vector(255 downto 0);

      -- Audio output (Signed PCM)
      main_audio_left_o       : out   signed(15 downto 0);
      main_audio_right_o      : out   signed(15 downto 0);

      -- M2M Keyboard interface (incl. power led and drive led)
      main_kb_key_num_i       : in    integer range 0 to 79; -- cycles through all MEGA65 keys
      main_kb_key_pressed_n_i : in    std_logic;             -- low active: debounced feedback: is kb_key_num_i pressed right now?
      main_power_led_o        : out   std_logic;
      main_power_led_col_o    : out   std_logic_vector(23 downto 0);
      main_drive_led_o        : out   std_logic;
      main_drive_led_col_o    : out   std_logic_vector(23 downto 0);

      -- Joysticks and paddles input
      main_joy_1_up_n_i       : in    std_logic;
      main_joy_1_down_n_i     : in    std_logic;
      main_joy_1_left_n_i     : in    std_logic;
      main_joy_1_right_n_i    : in    std_logic;
      main_joy_1_fire_n_i     : in    std_logic;
      main_joy_1_up_n_o       : out   std_logic;
      main_joy_1_down_n_o     : out   std_logic;
      main_joy_1_left_n_o     : out   std_logic;
      main_joy_1_right_n_o    : out   std_logic;
      main_joy_1_fire_n_o     : out   std_logic;
      main_joy_2_up_n_i       : in    std_logic;
      main_joy_2_down_n_i     : in    std_logic;
      main_joy_2_left_n_i     : in    std_logic;
      main_joy_2_right_n_i    : in    std_logic;
      main_joy_2_fire_n_i     : in    std_logic;
      main_joy_2_up_n_o       : out   std_logic;
      main_joy_2_down_n_o     : out   std_logic;
      main_joy_2_left_n_o     : out   std_logic;
      main_joy_2_right_n_o    : out   std_logic;
      main_joy_2_fire_n_o     : out   std_logic;

      main_pot1_x_i           : in    std_logic_vector(7 downto 0);
      main_pot1_y_i           : in    std_logic_vector(7 downto 0);
      main_pot2_x_i           : in    std_logic_vector(7 downto 0);
      main_pot2_y_i           : in    std_logic_vector(7 downto 0);
      main_rtc_i              : in    std_logic_vector(64 downto 0);

      -- CBM-488/IEC serial port
      iec_reset_n_o           : out   std_logic;
      iec_atn_n_o             : out   std_logic;
      iec_clk_en_o            : out   std_logic;
      iec_clk_n_i             : in    std_logic;
      iec_clk_n_o             : out   std_logic;
      iec_data_en_o           : out   std_logic;
      iec_data_n_i            : in    std_logic;
      iec_data_n_o            : out   std_logic;
      iec_srq_en_o            : out   std_logic;
      iec_srq_n_i             : in    std_logic;
      iec_srq_n_o             : out   std_logic;

      -- C64 Expansion Port (aka Cartridge Port)
      cart_en_o               : out   std_logic;             -- Enable port, active high
      cart_phi2_o             : out   std_logic;
      cart_dotclock_o         : out   std_logic;
      cart_dma_i              : in    std_logic;
      cart_reset_oe_o         : out   std_logic;
      cart_reset_i            : in    std_logic;
      cart_reset_o            : out   std_logic;
      cart_game_oe_o          : out   std_logic;
      cart_game_i             : in    std_logic;
      cart_game_o             : out   std_logic;
      cart_exrom_oe_o         : out   std_logic;
      cart_exrom_i            : in    std_logic;
      cart_exrom_o            : out   std_logic;
      cart_nmi_oe_o           : out   std_logic;
      cart_nmi_i              : in    std_logic;
      cart_nmi_o              : out   std_logic;
      cart_irq_oe_o           : out   std_logic;
      cart_irq_i              : in    std_logic;
      cart_irq_o              : out   std_logic;
      cart_roml_oe_o          : out   std_logic;
      cart_roml_i             : in    std_logic;
      cart_roml_o             : out   std_logic;
      cart_romh_oe_o          : out   std_logic;
      cart_romh_i             : in    std_logic;
      cart_romh_o             : out   std_logic;
      cart_ctrl_oe_o          : out   std_logic;             -- 0 : tristate (i.e. input), 1 : output
      cart_ba_i               : in    std_logic;
      cart_rw_i               : in    std_logic;
      cart_io1_i              : in    std_logic;
      cart_io2_i              : in    std_logic;
      cart_ba_o               : out   std_logic;
      cart_rw_o               : out   std_logic;
      cart_io1_o              : out   std_logic;
      cart_io2_o              : out   std_logic;
      cart_addr_oe_o          : out   std_logic;             -- 0 : tristate (i.e. input), 1 : output
      cart_a_i                : in    unsigned(15 downto 0);
      cart_a_o                : out   unsigned(15 downto 0);
      cart_data_oe_o          : out   std_logic;             -- 0 : tristate (i.e. input), 1 : output
      cart_d_i                : in    unsigned( 7 downto 0);
      cart_d_o                : out   unsigned( 7 downto 0);
      uart_tx_o               : out   std_logic;
      uart_rx_i               : in    std_logic
   );
end entity mega65_core;

architecture synthesis of mega65_core is

   constant C_VIDEO_MODE : video_modes_t := C_HDMI_640x480p_60;

   signal   main_life_ready   : std_logic;
   signal   main_life_addr    : std_logic_vector(9 downto 0);
   signal   main_life_wr_data : std_logic_vector(G_COLS-1 downto 0);
   signal   main_life_wr_en   : std_logic;
   signal   main_life_step    : std_logic;
   signal   main_life_count   : std_logic_vector(15 downto 0);

   signal   main_controller_busy    : std_logic;
   signal   main_controller_addr    : std_logic_vector(9 downto 0);
   signal   main_controller_wr_data : std_logic_vector(G_COLS-1 downto 0);
   signal   main_controller_wr_en   : std_logic;

   signal   main_tdp_addr    : std_logic_vector(9 downto 0);
   signal   main_tdp_rd_data : std_logic_vector(G_COLS-1 downto 0);
   signal   main_tdp_wr_data : std_logic_vector(G_COLS-1 downto 0);
   signal   main_tdp_wr_en   : std_logic;

   signal   video_count    : std_logic_vector(15 downto 0);
   signal   video_mem_addr : std_logic_vector(9 downto 0);
   signal   video_mem_data : std_logic_vector(G_COLS-1 downto 0);

begin

   -- MMCME2_ADV clock generators:
   clk_inst : entity work.clk
      port map (
         sys_clk_i   => clk_i,
         video_clk_o => video_clk_o,
         video_rst_o => video_rst_o,
         main_clk_o  => main_clk_o,
         main_rst_o  => main_rst_o
      ); -- clk_inst

   -- Instantiate main
   life_inst : entity work.life
      generic map (
         G_ROWS => G_ROWS,
         G_COLS => G_COLS
      )
      port map (
         clk_i     => main_clk_o,
         rst_i     => main_rst_o,
         ready_o   => main_life_ready,
         step_i    => main_life_step,
         addr_o    => main_life_addr,
         rd_data_i => main_tdp_rd_data,
         wr_data_o => main_life_wr_data,
         wr_en_o   => main_life_wr_en
      ); -- life_inst

   controller_wrapper_inst : entity work.controller_wrapper
      generic map (
         G_MAIN_CLK_HZ   => CORE_CLK_SPEED,
         G_UART_BAUDRATE => G_UART_BAUDRATE,
         G_ROWS          => G_ROWS,
         G_COLS          => G_COLS
      )
      port map (
         main_clk_i              => main_clk_o,
         main_rst_i              => main_rst_o,
         main_kb_key_num_i       => main_kb_key_num_i,
         main_kb_key_pressed_n_i => main_kb_key_pressed_n_i,
         uart_tx_o               => uart_tx_o,
         uart_rx_i               => uart_rx_i,
         main_life_ready_i       => main_life_ready,
         main_life_step_o        => main_life_step,
         main_life_count_o       => main_life_count,
         main_board_busy_o       => main_controller_busy,
         main_board_addr_o       => main_controller_addr,
         main_board_rd_data_i    => main_tdp_rd_data,
         main_board_wr_data_o    => main_controller_wr_data,
         main_board_wr_en_o      => main_controller_wr_en
      ); -- controller_wrapper_inst

   main_tdp_addr    <= main_controller_addr when main_controller_busy = '1' else
                       main_life_addr;
   main_tdp_wr_data <= main_controller_wr_data when main_controller_busy = '1' else
                       main_life_wr_data;
   main_tdp_wr_en   <= main_controller_wr_en when main_controller_busy = '1' else
                       main_life_wr_en;

   tdp_ram_inst : entity work.tdp_ram
      generic map (
         ADDR_WIDTH => 10,
         DATA_WIDTH => G_COLS
      )
      port map (
         clock_a   => main_clk_o,
         clen_a    => '1',
         address_a => main_tdp_addr,
         data_a    => main_tdp_wr_data,
         wren_a    => main_tdp_wr_en,
         q_a       => main_tdp_rd_data,

         clock_b   => video_clk_o,
         clen_b    => '1',
         address_b => video_mem_addr,
         data_b    => (others => '0'),
         wren_b    => '0',
         q_b       => video_mem_data
      ); -- tdp_ram_inst



   ---------------------------------------------------------------------------------------------
   -- Video output
   ---------------------------------------------------------------------------------------------

   xpm_cdc_array_single_inst : component xpm_cdc_array_single
      generic map (
         WIDTH => 16
      )
      port map (
         src_clk  => main_clk_o,
         src_in   => main_life_count,
         dest_clk => video_clk_o,
         dest_out => video_count
      ); -- xpm_cdc_array_single_inst

   video_wrapper_inst : entity work.video_wrapper
      generic map (
         G_VIDEO_MODE => C_VIDEO_MODE,
         G_FONT_PATH  => G_FONT_PATH,
         G_ROWS       => G_ROWS,
         G_COLS       => G_COLS
      )
      port map (
         video_clk_i    => video_clk_o,
         video_rst_i    => video_rst_o,
         video_addr_o   => video_mem_addr,
         video_data_i   => video_mem_data,
         video_count_i  => video_count,
         video_ce_o     => video_ce_o,
         video_ce_ovl_o => video_ce_ovl_o,
         video_red_o    => video_red_o,
         video_green_o  => video_green_o,
         video_blue_o   => video_blue_o,
         video_vs_o     => video_vs_o,
         video_hs_o     => video_hs_o,
         video_hblank_o => video_hblank_o,
         video_vblank_o => video_vblank_o
      ); -- video_wrapper_inst


   ---------------------------------------------------------------------------------------------
   -- Default values
   ---------------------------------------------------------------------------------------------

   cart_addr_oe_o          <= '0';
   cart_a_o                <= (others => '0');
   cart_ba_o               <= '0';
   cart_ctrl_oe_o          <= '0';
   cart_data_oe_o          <= '0';
   cart_d_o                <= (others => '0');
   cart_dotclock_o         <= '0';
   cart_en_o               <= '0';
   cart_exrom_o            <= '1';
   cart_exrom_oe_o         <= '0';
   cart_game_o             <= '1';
   cart_game_oe_o          <= '0';
   cart_io1_o              <= '0';
   cart_io2_o              <= '0';
   cart_irq_o              <= '1';
   cart_irq_oe_o           <= '0';
   cart_nmi_o              <= '1';
   cart_nmi_oe_o           <= '0';
   cart_phi2_o             <= '0';
   cart_reset_o            <= '1';
   cart_reset_oe_o         <= '0';
   cart_romh_o             <= '0';
   cart_romh_oe_o          <= '0';
   cart_roml_o             <= '0';
   cart_roml_oe_o          <= '0';
   cart_rw_o               <= '0';
   hr_core_address_o       <= (others => '0');
   hr_core_burstcount_o    <= (others => '0');
   hr_core_byteenable_o    <= (others => '0');
   hr_core_read_o          <= '0';
   hr_core_writedata_o     <= (others => '0');
   hr_core_write_o         <= '0';
   main_drive_led_col_o    <= x"00FF00"; -- 24-bit RGB value for the led
   main_drive_led_o        <= '0';
   main_joy_1_down_n_o     <= '1';
   main_joy_1_fire_n_o     <= '1';
   main_joy_1_left_n_o     <= '1';
   main_joy_1_right_n_o    <= '1';
   main_joy_1_up_n_o       <= '1';
   main_joy_2_down_n_o     <= '1';
   main_joy_2_fire_n_o     <= '1';
   main_joy_2_left_n_o     <= '1';
   main_joy_2_right_n_o    <= '1';
   main_joy_2_up_n_o       <= '1';
   main_power_led_col_o    <= x"0000FF" when main_reset_m2m_i else
                              x"00FF00";
   main_power_led_o        <= '1';
   qnice_ascal_mode_o      <= "00";
   qnice_ascal_polyphase_o <= '0';
   qnice_ascal_triplebuf_o <= '0';
   qnice_audio_filter_o    <= '0';       -- 0 = raw audio, 1 = use filters from globals.vhd
   qnice_audio_mute_o      <= '0';       -- audio is not muted
   qnice_csync_o           <= '0';
   qnice_dev_data_o        <= x"EEEE";
   qnice_dev_wait_o        <= '0';
   qnice_dvi_o             <= '1';       -- 0=HDMI (with sound), 1=DVI (no sound)
   qnice_flip_joyports_o   <= '0';
   qnice_osm_cfg_scaling_o <= (others => '1');
   qnice_retro15khz_o      <= '0';
   qnice_scandoubler_o     <= '0';       -- no scandoubler
   qnice_video_mode_o      <= C_VIDEO_HDMI_640_60;
   qnice_zoom_crop_o       <= '0';       -- 0 = no zoom/crop

end architecture synthesis;

