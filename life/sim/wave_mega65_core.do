onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/clk_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/rst_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/ready_o
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/step_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/addr_o
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/rd_data_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/wr_data_o
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/wr_en_o
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/state
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_clk_i
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_rst_i
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_kb_key_num_i
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_kb_key_pressed_n_i
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/uart_tx_o
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/uart_rx_i
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_ready_i
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_step_o
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_count_o
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_busy_o
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_addr_o
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_rd_data_i
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_wr_data_o
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_wr_en_o
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_ready
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_valid
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_data
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_ready
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_valid
add wave -noupdate -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_data
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/clk_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/rst_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/main_kb_key_num_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/main_kb_key_pressed_n_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_rx_valid_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_rx_ready_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_rx_data_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_tx_valid_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_tx_ready_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_tx_data_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/ready_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/step_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_busy_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_addr_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_rd_data_i
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_wr_data_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_wr_en_o
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/state
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/cur_col
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/cur_row
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/lfsr_output
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/rand7
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/key_num
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/key_pressed
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/key_released
add wave -noupdate -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/step_counter
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/clock_a
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/clen_a
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/address_a
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/data_a
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/wren_a
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/q_a
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/clock_b
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/clen_b
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/address_b
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/data_b
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/wren_b
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/q_b
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/address_a_reg
add wave -noupdate -group tdp_ram /tb_mega65_core/mega65_core_inst/tdp_ram_inst/address_b_reg
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_clk_i
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_rst_i
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_count_i
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_addr_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_data_i
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_ce_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_ce_ovl_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_red_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_green_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_blue_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_vs_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_hs_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_hblank_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_vblank_o
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_x
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_y
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_char
add wave -noupdate -group video_wrapper /tb_mega65_core/mega65_core_inst/video_wrapper_inst/video_colors
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_clk_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_rst_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_ce_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_ce_ovl_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_red_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_green_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_blue_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_vs_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_hs_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_hblank_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_vblank_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_clk_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_rst_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_kb_key_num_i
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_kb_key_pressed_n_i
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/uart_tx_o
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/uart_rx_i
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_life_ready
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_life_addr
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_life_wr_data
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_life_wr_en
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_life_step
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_life_count
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_controller_busy
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_controller_addr
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_controller_wr_data
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_controller_wr_en
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_tdp_addr
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_tdp_rd_data
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_tdp_wr_data
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/main_tdp_wr_en
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_count
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_mem_addr
add wave -noupdate -expand -group mega65_core /tb_mega65_core/mega65_core_inst/video_mem_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53320426151 fs} 0}
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
WaveRestoreZoom {53067069412 fs} {53444125935 fs}