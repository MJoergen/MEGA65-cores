onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb /tb_life/running
add wave -noupdate -group tb /tb_life/rst
add wave -noupdate -group tb /tb_life/clk
add wave -noupdate -group tb /tb_life/ready
add wave -noupdate -group tb /tb_life/en
add wave -noupdate -group tb /tb_life/addr
add wave -noupdate -group tb /tb_life/rd_data
add wave -noupdate -group tb /tb_life/wr_data
add wave -noupdate -group tb /tb_life/wr_en
add wave -noupdate -group tb /tb_life/tb_wr_row
add wave -noupdate -group tb /tb_life/tb_wr_col
add wave -noupdate -group tb /tb_life/tb_wr_value
add wave -noupdate -group tb /tb_life/tb_wr_en
add wave -noupdate -group tb /tb_life/board
add wave -noupdate -expand -group life /tb_life/life_inst/clk_i
add wave -noupdate -expand -group life /tb_life/life_inst/rst_i
add wave -noupdate -expand -group life /tb_life/life_inst/ready_o
add wave -noupdate -expand -group life /tb_life/life_inst/step_i
add wave -noupdate -expand -group life /tb_life/life_inst/addr_o
add wave -noupdate -expand -group life /tb_life/life_inst/rd_data_i
add wave -noupdate -expand -group life /tb_life/life_inst/wr_data_o
add wave -noupdate -expand -group life /tb_life/life_inst/wr_en_o
add wave -noupdate -expand -group life /tb_life/life_inst/state
add wave -noupdate -expand -group life /tb_life/life_inst/rd_addr
add wave -noupdate -expand -group life /tb_life/life_inst/wr_addr
add wave -noupdate -expand -group life /tb_life/life_inst/row_first
add wave -noupdate -expand -group life /tb_life/life_inst/row_cur
add wave -noupdate -expand -group life /tb_life/life_inst/row_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {275698324 fs} 0}
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
WaveRestoreZoom {0 fs} {1050 ns}
