# Radiant build script for LED Blinker project
# Run with: radiantc -t build.tcl

# Create new project
prj_create -name "led_blinker" -impl "impl_1" -dev LFCPNX-100-9BBG484C -synthesis "synplify"

# Add source files
prj_add_source "led_blinker.v"
prj_add_source "led_blinker_top.v"

# Add constraints files
prj_add_source "led_blinker.pdc"
prj_add_source "led_blinker.sdc"

# Set top level module
prj_set_impl_opt top "led_blinker_top"

# Synthesis options
prj_set_impl_opt {include path} ""
prj_set_impl_opt {syn_keep_hierarchy} "rebuilt"
prj_set_impl_opt {syn_frequency} "100.0"

# Implementation options  
prj_set_impl_opt {buskeep} "0"

# Save project
prj_save

# Run synthesis
prj_run_synthesis

# Run place and route
prj_run_map
prj_run_par

# Generate bitstream
prj_run_export

puts "Build complete! Bitstream generated in impl_1 directory"