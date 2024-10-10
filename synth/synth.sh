
#!/bin/sh

TOP=GPIO

set -e

if [ -e generated ]; then 
    if [ -e generated/synth.tcl ]; then 
        rm -f generated/synth.tcl
    fi
fi

touch generated/synth.tcl

echo "set top ${TOP}" >> generated/synth.tcl
echo "set techLib ../synth/stdcells.lib" >> generated/synth.tcl
echo "yosys -import" >> generated/synth.tcl
echo "set f [open filelist.f]" >> generated/synth.tcl
echo "while {[gets \$f line] > -1} {" >> generated/synth.tcl
echo "  read_verilog -sv \$line" >> generated/synth.tcl
echo "}" >> generated/synth.tcl
echo "close \$f" >> generated/synth.tcl
echo "hierarchy -check -top \$top" >> generated/synth.tcl
echo "synth -top \$top" >> generated/synth.tcl
echo "flatten" >> generated/synth.tcl
echo "dfflibmap -liberty \$techLib" >> generated/synth.tcl
echo "abc -liberty \$techLib" >> generated/synth.tcl
echo "opt_clean -purge" >> generated/synth.tcl
echo "write_verilog -noattr \$top\_net.v" >> generated/synth.tcl
echo "stat -liberty \$techLib" >> generated/synth.tcl

cd generated
yosys -Qv 1 synth.tcl
