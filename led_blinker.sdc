# Timing constraints for LED Blinker
# Assuming 50 MHz input clock

# Create clock constraint
# 50 MHz = 20 ns period
create_clock -name CLK -period 20.0 [get_ports CLK]

# Set input delays for reset
set_input_delay -clock CLK -max 5.0 [get_ports RST_N]
set_input_delay -clock CLK -min 1.0 [get_ports RST_N]

# Set output delays for LEDs
set_output_delay -clock CLK -max 5.0 [get_ports LED*]
set_output_delay -clock CLK -min 1.0 [get_ports LED*]

# Set false paths for asynchronous reset
set_false_path -from [get_ports RST_N] -to [all_registers]

# Clock uncertainty
set_clock_uncertainty -setup 0.2 [get_clocks CLK]
set_clock_uncertainty -hold 0.1 [get_clocks CLK]