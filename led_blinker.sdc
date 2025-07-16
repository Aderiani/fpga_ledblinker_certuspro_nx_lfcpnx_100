# Timing constraints file for LED Blinker
# Synopsys Design Constraints (SDC) format

# Define the main clock
create_clock -name CLK_50MHZ -period 20.0 [get_ports CLK_50MHZ]

# Set clock uncertainty
set_clock_uncertainty -setup 0.2 [get_clocks CLK_50MHZ]
set_clock_uncertainty -hold 0.1 [get_clocks CLK_50MHZ]

# Set input delays for reset
set_input_delay -clock CLK_50MHZ -max 5.0 [get_ports RST_N]
set_input_delay -clock CLK_50MHZ -min 1.0 [get_ports RST_N]

# Set output delays for LEDs
set_output_delay -clock CLK_50MHZ -max 5.0 [get_ports LED*]
set_output_delay -clock CLK_50MHZ -min -1.0 [get_ports LED*]

# Set false paths for asynchronous reset
set_false_path -from [get_ports RST_N]

# Set maximum fanout
set_max_fanout 20 [all_inputs]

# Set driving cell for inputs (typical buffer)
set_driving_cell -lib_cell IN -pin O [get_ports RST_N]

# Set load for outputs (typical LED load)
set_load 10 [get_ports LED*]