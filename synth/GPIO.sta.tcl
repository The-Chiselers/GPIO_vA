set top "GPIO"

read_liberty ../synth/stdcells.lib
read_verilog $top\_net.v
link_design $top
source ../generated/$top.sdc
check_setup
report_checks