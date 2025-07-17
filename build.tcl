#!/usr/bin/env tclsh
# Simple build script for LED Blinker
# Run with: radiantc -t simple_build.tcl

# Create new project
prj_create -name "led_blinker" -impl "impl_1" -dev LFCPNX-100-9BBG484C -performance 9_High-Performance_1.0V -synthesis "lse"

# Add source files
prj_add_source "simple_led_blinker.v"

# Add constraint file
prj_add_source "simple_led_blinker.pdc"

# Save project
prj_save

# Run all implementation steps
prj_run Synthesis -impl impl_1
prj_run Map -impl impl_1
prj_run PAR -impl impl_1
prj_run Export -impl impl_1 -task Bitgen

puts "Build complete! Bitstream should be in impl_1 directory"