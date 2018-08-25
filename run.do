vlib work
vdel -all
vlib work

vlog alu_input_stage.v +acc
vlog alu_output_stage.v +acc
vlog exdbin_mac.v +acc
vlog exdbin_mac_test.v +acc
vlog holdreg.v +acc
vlog holdreg_test.v +acc
vlog mux_out.v +acc
vlog mux_test.v +acc
vlog priority.v +acc
vlog shifter.v +acc
vlog calc1_top.v +acc
vlog tb.v -sv +acc
#vlog my_tb.v -sv +acc

vsim work.test

do wave.do

run -all