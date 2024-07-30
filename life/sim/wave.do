onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_clk_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_rst_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dvi_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_video_mode_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_osm_cfg_scaling_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_scandoubler_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_audio_mute_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_audio_filter_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_zoom_crop_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_ascal_mode_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_ascal_polyphase_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_ascal_triplebuf_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_retro15khz_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_csync_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_flip_joyports_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_osm_control_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_gp_reg_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dev_id_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dev_addr_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dev_data_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dev_data_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dev_ce_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dev_we_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/qnice_dev_wait_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_clk_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_rst_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_write_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_read_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_address_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_writedata_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_byteenable_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_burstcount_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_readdata_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_readdatavalid_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_core_waitrequest_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_high_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/hr_low_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_clk_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_rst_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_ce_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_ce_ovl_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_red_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_green_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_blue_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_vs_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_hs_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_hblank_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/video_vblank_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/clk_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_clk_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_rst_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_reset_m2m_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_reset_core_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_pause_core_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_osm_control_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_qnice_gp_reg_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_audio_left_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_audio_right_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_kb_key_num_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_kb_key_pressed_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_power_led_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_power_led_col_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_drive_led_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_drive_led_col_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_up_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_down_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_left_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_right_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_fire_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_up_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_down_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_left_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_right_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_1_fire_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_up_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_down_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_left_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_right_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_fire_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_up_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_down_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_left_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_right_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_joy_2_fire_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_pot1_x_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_pot1_y_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_pot2_x_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_pot2_y_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_rtc_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_reset_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_atn_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_clk_en_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_clk_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_clk_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_data_en_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_data_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_data_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_srq_en_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_srq_n_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/iec_srq_n_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_en_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_phi2_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_dotclock_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_dma_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_reset_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_reset_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_reset_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_game_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_game_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_game_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_exrom_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_exrom_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_exrom_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_nmi_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_nmi_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_nmi_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_irq_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_irq_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_irq_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_roml_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_roml_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_roml_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_romh_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_romh_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_romh_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_ctrl_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_ba_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_rw_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_io1_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_io2_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_ba_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_rw_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_io1_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_io2_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_addr_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_a_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_a_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_data_oe_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_d_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/cart_d_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/uart_tx_o
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/uart_rx_i
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_uart_rx_ready
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_uart_rx_valid
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_uart_rx_data
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_uart_tx_ready
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_uart_tx_valid
add wave -noupdate -group mega65_core /tb_mega65_core/mega65_core_inst/main_uart_tx_data
add wave -noupdate -group uart /tb_mega65_core/mega65_core_inst/uart_inst/clk_i
add wave -noupdate -group uart /tb_mega65_core/mega65_core_inst/uart_inst/rst_i
add wave -noupdate -group uart -color blue /tb_mega65_core/mega65_core_inst/uart_inst/rx_ready_i
add wave -noupdate -group uart -color gold /tb_mega65_core/mega65_core_inst/uart_inst/rx_valid_o
add wave -noupdate -group uart /tb_mega65_core/mega65_core_inst/uart_inst/rx_data_o
add wave -noupdate -group uart -color blue /tb_mega65_core/mega65_core_inst/uart_inst/tx_ready_o
add wave -noupdate -group uart -color gold /tb_mega65_core/mega65_core_inst/uart_inst/tx_valid_i
add wave -noupdate -group uart /tb_mega65_core/mega65_core_inst/uart_inst/tx_data_i
add wave -noupdate -group uart /tb_mega65_core/mega65_core_inst/uart_inst/uart_tx_o
add wave -noupdate -group uart /tb_mega65_core/mega65_core_inst/uart_inst/uart_rx_i
add wave -noupdate -group uart -group Internal /tb_mega65_core/mega65_core_inst/uart_inst/tx_data
add wave -noupdate -group uart -group Internal /tb_mega65_core/mega65_core_inst/uart_inst/tx_state
add wave -noupdate -group uart -group Internal /tb_mega65_core/mega65_core_inst/uart_inst/tx_counter
add wave -noupdate -group uart -group Internal /tb_mega65_core/mega65_core_inst/uart_inst/rx_data
add wave -noupdate -group uart -group Internal /tb_mega65_core/mega65_core_inst/uart_inst/rx_state
add wave -noupdate -group uart -group Internal /tb_mega65_core/mega65_core_inst/uart_inst/rx_counter
add wave -noupdate -group uart -group Internal /tb_mega65_core/mega65_core_inst/uart_inst/uart_tx
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/rst_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/clk_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/en_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/board_o
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/index_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/value_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/update_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/board
add wave -noupdate -expand -group uart_dumper /tb_mega65_core/uart_dumper_inst/clk_i
add wave -noupdate -expand -group uart_dumper /tb_mega65_core/uart_dumper_inst/rst_i
add wave -noupdate -expand -group uart_dumper /tb_mega65_core/uart_dumper_inst/rx_ready_i
add wave -noupdate -expand -group uart_dumper /tb_mega65_core/uart_dumper_inst/rx_valid_i
add wave -noupdate -expand -group uart_dumper /tb_mega65_core/uart_dumper_inst/rx_data_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {945291210 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {873983508 fs} {8885912436 fs}
