vlog -sv ./rtl/alu.sv
vlog -sv ./tb/alu_tb.sv

vsim -voptargs=+acc work.alu_tb

radix -decimal

add wave -position end  sim:/alu_tb/in_a
add wave -position end  sim:/alu_tb/in_b
add wave -position end  sim:/alu_tb/out
add wave -position end  sim:/alu_tb/opcode

add wave -divider -height 30 "OVERFLOW"
add wave -position end  sim:/alu_tb/flags[2]
add wave -divider -height 30 "NEGATIVE"
add wave -position end  sim:/alu_tb/flags[1]
add wave -divider -height 30 "ZERO"
add wave -position end  sim:/alu_tb/flags[0]

add wave -divider -height 30 "ERROR"
add wave -position end  sim:/alu_tb/error

radix signal sim:/alu_tb/opcode binary

run 495ns
