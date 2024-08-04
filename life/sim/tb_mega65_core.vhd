----------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework
--
-- MEGA65 main file that contains the whole machine
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
----------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

library work;
   use work.globals.all;

entity tb_mega65_core is
   generic (
      G_COLS  : integer := 160;
      G_ROWS  : integer := 89;
      G_BOARD : string -- Which platform are we running on.
   );
end entity tb_mega65_core;

architecture simulation of tb_mega65_core is

   constant C_UART_BAUDRATE : natural := 20_000_000;

   signal   sys_clk : std_logic       := '1';
   signal   sys_rst : std_logic       := '1';
   signal   running : std_logic       := '1';

   signal   main_clk : std_logic;
   signal   main_rst : std_logic;

   signal   main_rx_ready : std_logic;
   signal   main_rx_valid : std_logic;
   signal   main_rx_data  : std_logic_vector(7 downto 0);
   signal   main_tx_ready : std_logic;
   signal   main_tx_valid : std_logic;
   signal   main_tx_data  : std_logic_vector(7 downto 0);

   signal   main_uart_tx : std_logic;
   signal   main_uart_rx : std_logic;

begin

   sys_clk <= not sys_clk after 5 ns; -- 100 MHz
   sys_rst <= '1', '0' after 100 ns;

   test_proc : process
      --

      procedure uart_send_byte (
         arg : std_logic_vector(7 downto 0)
      ) is
      begin
         main_tx_data  <= arg;
         main_tx_valid <= '1';
         wait until main_clk = '1';

         while main_tx_ready = '0' loop
            wait until main_clk = '1';
         end loop;

         main_tx_valid <= '0';
      end procedure uart_send_byte;

      procedure uart_send (
         arg : string
      ) is
         variable c_v : character;
      begin
         --
         for idx in arg'range loop
            c_v := arg(idx);
            uart_send_byte(to_stdlogicvector(character'pos(c_v), 8));
         end loop;

      --
      end procedure uart_send;

   --
   begin
      wait for 10 ns;
      wait until main_rst = '0';
      wait until main_clk = '1';
      report "Test started";
      wait for 2 us;

      uart_send("P");
      wait for 50 us;

      uart_send("S");
      wait for 2 us;
      uart_send("P");
      wait for 50 us;

      uart_send("S");
      wait for 2 us;
      uart_send("P");
      wait for 50 us;

      report "Test finished";
      running <= '0';
      wait;
   end process test_proc;

   -- Instantiate DUT
   mega65_core_inst : entity work.mega65_core
      generic map (
         G_FONT_PATH     => "../vhdl/video/",
         G_UART_BAUDRATE => C_UART_BAUDRATE,
         G_ROWS          => G_ROWS,
         G_COLS          => G_COLS,
         G_BOARD         => G_BOARD
      )
      port map (
         qnice_clk_i             => '0',
         qnice_rst_i             => '1',
         qnice_dvi_o             => open,
         qnice_video_mode_o      => open,
         qnice_osm_cfg_scaling_o => open,
         qnice_scandoubler_o     => open,
         qnice_audio_mute_o      => open,
         qnice_audio_filter_o    => open,
         qnice_zoom_crop_o       => open,
         qnice_ascal_mode_o      => open,
         qnice_ascal_polyphase_o => open,
         qnice_ascal_triplebuf_o => open,
         qnice_retro15khz_o      => open,
         qnice_csync_o           => open,
         qnice_flip_joyports_o   => open,
         qnice_osm_control_i     => (others => '0'),
         qnice_gp_reg_i          => (others => '0'),
         qnice_dev_id_i          => (others => '0'),
         qnice_dev_addr_i        => (others => '0'),
         qnice_dev_data_i        => (others => '0'),
         qnice_dev_data_o        => open,
         qnice_dev_ce_i          => '0',
         qnice_dev_we_i          => '0',
         qnice_dev_wait_o        => open,
         hr_clk_i                => '0',
         hr_rst_i                => '1',
         hr_core_write_o         => open,
         hr_core_read_o          => open,
         hr_core_address_o       => open,
         hr_core_writedata_o     => open,
         hr_core_byteenable_o    => open,
         hr_core_burstcount_o    => open,
         hr_core_readdata_i      => (others => '0'),
         hr_core_readdatavalid_i => '0',
         hr_core_waitrequest_i   => '0',
         hr_high_i               => '0',
         hr_low_i                => '0',
         video_clk_o             => open,
         video_rst_o             => open,
         video_ce_o              => open,
         video_ce_ovl_o          => open,
         video_red_o             => open,
         video_green_o           => open,
         video_blue_o            => open,
         video_vs_o              => open,
         video_hs_o              => open,
         video_hblank_o          => open,
         video_vblank_o          => open,
         clk_i                   => sys_clk,
         main_clk_o              => main_clk,
         main_rst_o              => main_rst,
         main_reset_m2m_i        => '0',
         main_reset_core_i       => '0',
         main_pause_core_i       => '0',
         main_osm_control_i      => (5 => '1', 16 => '1', others => '0'),
         main_qnice_gp_reg_i     => (others => '0'),
         main_audio_left_o       => open,
         main_audio_right_o      => open,
         main_kb_key_num_i       => 0,
         main_kb_key_pressed_n_i => '0',
         main_power_led_o        => open,
         main_power_led_col_o    => open,
         main_drive_led_o        => open,
         main_drive_led_col_o    => open,
         main_joy_1_up_n_i       => '0',
         main_joy_1_down_n_i     => '0',
         main_joy_1_left_n_i     => '0',
         main_joy_1_right_n_i    => '0',
         main_joy_1_fire_n_i     => '0',
         main_joy_1_up_n_o       => open,
         main_joy_1_down_n_o     => open,
         main_joy_1_left_n_o     => open,
         main_joy_1_right_n_o    => open,
         main_joy_1_fire_n_o     => open,
         main_joy_2_up_n_i       => '0',
         main_joy_2_down_n_i     => '0',
         main_joy_2_left_n_i     => '0',
         main_joy_2_right_n_i    => '0',
         main_joy_2_fire_n_i     => '0',
         main_joy_2_up_n_o       => open,
         main_joy_2_down_n_o     => open,
         main_joy_2_left_n_o     => open,
         main_joy_2_right_n_o    => open,
         main_joy_2_fire_n_o     => open,
         main_pot1_x_i           => (others => '0'),
         main_pot1_y_i           => (others => '0'),
         main_pot2_x_i           => (others => '0'),
         main_pot2_y_i           => (others => '0'),
         main_rtc_i              => (others => '0'),
         iec_reset_n_o           => open,
         iec_atn_n_o             => open,
         iec_clk_en_o            => open,
         iec_clk_n_i             => '0',
         iec_clk_n_o             => open,
         iec_data_en_o           => open,
         iec_data_n_i            => '0',
         iec_data_n_o            => open,
         iec_srq_en_o            => open,
         iec_srq_n_i             => '0',
         iec_srq_n_o             => open,
         cart_en_o               => open,
         cart_phi2_o             => open,
         cart_dotclock_o         => open,
         cart_dma_i              => '0',
         cart_reset_oe_o         => open,
         cart_reset_i            => '0',
         cart_reset_o            => open,
         cart_game_oe_o          => open,
         cart_game_i             => '0',
         cart_game_o             => open,
         cart_exrom_oe_o         => open,
         cart_exrom_i            => '0',
         cart_exrom_o            => open,
         cart_nmi_oe_o           => open,
         cart_nmi_i              => '0',
         cart_nmi_o              => open,
         cart_irq_oe_o           => open,
         cart_irq_i              => '0',
         cart_irq_o              => open,
         cart_roml_oe_o          => open,
         cart_roml_i             => '0',
         cart_roml_o             => open,
         cart_romh_oe_o          => open,
         cart_romh_i             => '0',
         cart_romh_o             => open,
         cart_ctrl_oe_o          => open,
         cart_ba_i               => '0',
         cart_rw_i               => '0',
         cart_io1_i              => '0',
         cart_io2_i              => '0',
         cart_ba_o               => open,
         cart_rw_o               => open,
         cart_io1_o              => open,
         cart_io2_o              => open,
         cart_addr_oe_o          => open,
         cart_a_i                => (others => '0'),
         cart_a_o                => open,
         cart_data_oe_o          => open,
         cart_d_i                => (others => '0'),
         cart_d_o                => open,
         uart_tx_o               => main_uart_tx,
         uart_rx_i               => main_uart_rx
      ); -- mega65_core_inst

   uart_inst : entity work.uart
      generic map (
         G_DIVISOR => CORE_CLK_SPEED / C_UART_BAUDRATE
      )
      port map (
         clk_i      => main_clk,
         rst_i      => main_rst,
         rx_ready_i => main_rx_ready,
         rx_valid_o => main_rx_valid,
         rx_data_o  => main_rx_data,
         tx_ready_o => main_tx_ready,
         tx_valid_i => main_tx_valid,
         tx_data_i  => main_tx_data,
         uart_tx_o  => main_uart_rx, -- purposely swapped: Testbench TX is the same as DUT RX
         uart_rx_i  => main_uart_tx
      ); -- uart_inst

   main_rx_ready <= '1';

   uart_dumper_inst : entity work.uart_dumper
      port map (
         clk_i      => main_clk,
         rst_i      => main_rst,
         rx_ready_i => main_rx_ready,
         rx_valid_i => main_rx_valid,
         rx_data_i  => main_rx_data
      ); -- uart_dumper_inst

end architecture simulation;

