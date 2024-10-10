import os
import sys
import re

def main():
    TOP=sys.argv[1]
    OUTPUT=sys.argv[2]

    netlist_path = os.path.join("generated", f"{TOP}_net.v")
    netlist = open(netlist_path, "r").read()
    
    # ports look like this:
    # module ${TOP}(.*?);
    ports = re.search(r"module\s+{}\s*\((.*?)\);".format(TOP), netlist, re.DOTALL).group(1).split(",")
    ports = [port.strip() for port in ports]
    
    ports_map = {}
    for port in ports:
        ports_map[port] = "NONE"

    # for each line if matches input or output, add to ports_map if port is in map
    # input clock;
    # output reset;
    # input [31:0] io_apb_PADDR;
    for line in netlist.split("\n"):
        if "input" in line or "output" in line:
            port = re.search(r"(input|output)\s+(?:\[\d+:\d+\])?\s*(.*?);", line).group(2)
            if port in ports_map:
                ports_map[port] = re.search(r"(input|output)", line).group(1)
    
    # create sdc file
    sdc = open(OUTPUT, "w")
    sdc.write("create_clock -period 5.0 -waveform {0 2.5} clock\n")

    inputs = []
    outputs = []
    for port, direction in ports_map.items():
        if direction == "input":
            inputs.append(port)
        elif direction == "output":
            outputs.append(port)

    for input_port in inputs:
        sdc.write("set_input_delay -clock clock 1.0 {" + input_port + "}\n")

    for output_port in outputs:
        sdc.write("set_output_delay -clock clock 1.0 {" + output_port + "}\n")



if __name__ == "__main__":
    main()