onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/clk_i
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/rst_i
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/start_i
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/startx_i
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/starty_i
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/stepx_i
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/stepy_i
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_addr_o
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_data_o
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_en_o
add wave -noupdate -expand -group dispatcher /tb_mega65_core/mega65_core_inst/dispatcher_inst/done_o
add wave -noupdate -expand -group dispatcher -radix unsigned /tb_mega65_core/mega65_core_inst/dispatcher_inst/wait_cnt_tot_o
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/sched_active_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/job_cx_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/job_stepx_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/job_starty_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/job_stepy_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/job_start_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/job_addr_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/cur_addr_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/job_busy_s
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/res_addr_s
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/res_data_s
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/res_valid_s
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/res_ack_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/res_busy_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wait_cnt_s
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wait_cnt_d
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_addr_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_data_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_en_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_addr_d
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_data_d
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wr_en_d
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/done_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/idx_start_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/idx_start_valid_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/idx_iterator_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/idx_valid_r
add wave -noupdate -expand -group dispatcher -group Internal /tb_mega65_core/mega65_core_inst/dispatcher_inst/wait_cnt_tot_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 178
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
