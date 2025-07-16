# Radiant build script for LED Blinker project
# Run with: radiantc -t build.tcl

# Create new project
prj_create -name "led_blinker" -impl "impl_1" -dev LFCPNX-100-9BBG484C -synthesis "synplify"

# Add source files
prj_add_source "led_blinker.v"
prj_add_source "led_blinker_top.v"

# Add constraints files
prj_add_source "led_blinker.pdc" -work "impl_1"
prj_add_source "led_blinker.sdc" -work "impl_1"

# Set top level module
prj_set_impl_opt -impl "impl_1" top "led_blinker_top"

# Synthesis options
prj_set_impl_opt -impl "impl_1" syn_keep_hierarchy "rebuilt"
prj_set_impl_opt -impl "impl_1" syn_freq "100.0"

# Implementation options
prj_set_impl_opt -impl "impl_1" map_auto_gsr "true"
prj_set_impl_opt -impl "impl_1" map_prioritize_pwrrail "false"

# Save project
prj_save

# Run synthesis
prj_run_synthesis -impl "impl_1" -task "Synplify_Synthesis"

# Run place and route
prj_run_map -impl "impl_1" -task "Map"
prj_run_par -impl "impl_1" -task "Place_Route"

# Generate bitstream
prj_run_export -impl "impl_1" -task "Bitgen"

puts "Build complete! Bitstream generated at: impl_1/led_blinker_impl_1.bit"