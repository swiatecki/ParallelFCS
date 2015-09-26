onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fcs_check_parallel_tb/fcs_error
add wave -noupdate /fcs_check_parallel_tb/reset
add wave -noupdate /fcs_check_parallel_tb/start_of_frame
add wave -noupdate /fcs_check_parallel_tb/end_of_frame
add wave -noupdate /fcs_check_parallel_tb/data_in
add wave -noupdate /fcs_check_parallel_tb/fcs/data_in_1
add wave -noupdate -color Magenta /fcs_check_parallel_tb/clk
add wave -noupdate /fcs_check_parallel_tb/i
add wave -noupdate /fcs_check_parallel_tb/fcs/G
add wave -noupdate -radix hexadecimal /fcs_check_parallel_tb/fcs/R
add wave -noupdate /fcs_check_parallel_tb/fcs/start_cnt
add wave -noupdate /fcs_check_parallel_tb/fcs/end_cnt
add wave -noupdate /fcs_check_parallel_tb/enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1830759 ps} 0} {{Cursor 2} {355533 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 322
configure wave -valuecolwidth 184
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1575 ns}
