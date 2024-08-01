onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group life /tb_life/life_inst/clk_i
add wave -noupdate -expand -group life /tb_life/life_inst/rst_i
add wave -noupdate -expand -group life /tb_life/life_inst/en_i
add wave -noupdate -expand -group life /tb_life/life_inst/board_o
add wave -noupdate -expand -group life /tb_life/life_inst/index_i
add wave -noupdate -expand -group life /tb_life/life_inst/value_i
add wave -noupdate -expand -group life /tb_life/life_inst/update_i
add wave -noupdate -expand -group life /tb_life/life_inst/board
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 fs} {22690 fs}
