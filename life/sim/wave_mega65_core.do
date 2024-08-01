onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/clk_i
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/rst_i
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/ready_o
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/step_i
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/addr_o
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/rd_data_i
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/wr_data_o
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/wr_en_o
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/board
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/state
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/addr
add wave -noupdate -expand -group life /tb_mega65_core/mega65_core_inst/life_inst/addr_d
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_clk_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_rst_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_kb_key_num_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_kb_key_pressed_n_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/uart_tx_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/uart_rx_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_ready_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_step_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_count_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_busy_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_addr_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_rd_data_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_wr_data_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_board_wr_en_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_ready
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_valid
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_data
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_ready
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_valid
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_data
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/clk_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/rst_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/main_kb_key_num_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/main_kb_key_pressed_n_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_rx_valid_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_rx_ready_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_rx_data_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_tx_valid_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_tx_ready_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/uart_tx_data_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/ready_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/step_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_busy_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_addr_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_rd_data_i
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_wr_data_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_wr_en_o
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/init_state
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/state
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/cur_col
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/cur_row
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/lfsr_output
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/rand7
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/key_num
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/key_pressed
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/key_released
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/step_counter
add wave -noupdate -expand -group controller /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/controller_inst/board_addr
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {194096837363 fs} 0}
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
WaveRestoreZoom {51465352829 fs} {59342021615 fs}
