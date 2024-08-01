onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/clk_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/rst_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/en_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/board_o
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/index_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/value_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/update_i
add wave -noupdate -group life /tb_mega65_core/mega65_core_inst/life_inst/board
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_clk_i
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_rst_i
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_ready_o
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_valid_i
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_board_i
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_addr_i
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_data_o
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/b_clk_i
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/b_addr_i
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/b_data_o
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_addr
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_data
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/a_wren
add wave -noupdate -group board_mem /tb_mega65_core/mega65_core_inst/board_mem_inst/state
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_clk_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_rst_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_kb_key_num_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_kb_key_pressed_n_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/uart_tx_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/uart_rx_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_board_addr_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_board_data_i
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_step_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_wr_index_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_wr_value_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_wr_en_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_init_done_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_life_count_o
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_ready
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_valid
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_rx_data
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_ready
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_valid
add wave -noupdate -expand -group controller_wrapper /tb_mega65_core/mega65_core_inst/controller_wrapper_inst/main_uart_tx_data
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
WaveRestoreZoom {0 fs} {105 us}
