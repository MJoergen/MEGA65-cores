onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group column /tb_column/i_column/clk_i
add wave -noupdate -expand -group column /tb_column/i_column/rst_i
add wave -noupdate -expand -group column /tb_column/i_column/job_start_i
add wave -noupdate -expand -group column /tb_column/i_column/job_cx_i
add wave -noupdate -expand -group column /tb_column/i_column/job_starty_i
add wave -noupdate -expand -group column /tb_column/i_column/job_stepy_i
add wave -noupdate -expand -group column /tb_column/i_column/job_busy_o
add wave -noupdate -expand -group column /tb_column/i_column/res_addr_o
add wave -noupdate -expand -group column /tb_column/i_column/res_ack_i
add wave -noupdate -expand -group column /tb_column/i_column/res_data_o
add wave -noupdate -expand -group column /tb_column/i_column/res_valid_o
add wave -noupdate -expand -group column /tb_column/i_column/wait_cnt_o
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_start_r
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_cx_r
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_cy_r
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_data_s
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_valid_s
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_addr_r
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/job_busy_r
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_addr_d
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_data_d
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_valid_d
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/res_valid_dd
add wave -noupdate -expand -group column -group Internal /tb_column/i_column/wait_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {90575725 fs} {5495217953 fs}
