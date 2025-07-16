# LED Pattern Blinker for GR740-MINI Board

This project implements a LED pattern generator for the CertusPro-NX FPGA on the GR740-MINI board.

## Features

- 5 different LED patterns that cycle automatically:
  1. **Binary Counter**: Counts from 0000 to 1111 in binary
  2. **Knight Rider**: LEDs scan left to right and back
  3. **Fill and Empty**: LEDs fill from right to left, then empty
  4. **Alternating Pairs**: Alternates between 1010 and 0101
  5. **All Blink**: All LEDs blink on and off together

- 50 MHz input clock with configurable blink rate
- Active-low reset input
- Drives 4 green LEDs (LED12-LED15)

## Files

- `led_blinker.v` - Main pattern generator module
- `led_blinker_top.v` - Top-level wrapper with I/O connections
- `led_blinker.pdc` - Pin constraints file
- `led_blinker.sdc` - Timing constraints file
- `led_blinker_tb.v` - Testbench for simulation
- `build.tcl` - Automated build script for Radiant

## Pin Assignments

**IMPORTANT**: The pin assignments in the PDC file are estimates. You must verify and update them based on your actual board schematic!

| Signal    | Pin  | Direction | Description |
|-----------|------|-----------|-------------|
| CLK_50MHZ | B20  | Input     | 50 MHz clock |
| RST_N     | A21  | Input     | Active-low reset |
| LED12     | E21  | Output    | LED 12 (Green) |
| LED13     | E22  | Output    | LED 13 (Green) |
| LED14     | F21  | Output    | LED 14 (Green) |
| LED15     | F22  | Output    | LED 15 (Green) |

## Building the Project

### Method 1: Using Radiant GUI

1. Open Lattice Radiant
2. Create a new project targeting LFCPNX-100-9BBG484C
3. Add all Verilog source files
4. Add constraint files
5. Set `led_blinker_top` as the top module
6. Run Synthesis → Map → Place & Route → Generate Bitstream

### Method 2: Using TCL Script

```bash
radiantc -t build.tcl
```

### Method 3: Manual Command Line

```bash
# Synthesis
synpwrap -prj led_blinker_syn.prj

# Implementation
radiantc led_blinker.rdf
```

## Simulation

To run the testbench:

1. Using ModelSim:
```bash
vlog led_blinker.v led_blinker_tb.v
vsim -do "run -all" led_blinker_tb
```

2. Using Radiant's built-in simulator:
   - Add testbench to project
   - Right-click on testbench → Set as simulation top
   - Run simulation

## Programming the FPGA

1. Connect JTAG programmer to the board
2. Power on the board
3. In Radiant: Tools → Programmer
4. Select the generated bitstream file
5. Click "Program"

## Customization

### Changing Blink Rate
Modify the `BLINK_FREQ` parameter in `led_blinker.v`:
```verilog
parameter BLINK_FREQ = 2;  // 2 Hz default
```

### Adding New Patterns
Add new states to the pattern state machine in `led_blinker.v`.

### Changing Clock Frequency
If using a different clock frequency, update:
1. `CLK_FREQ` parameter in `led_blinker.v`
2. Clock period in constraints files

## Troubleshooting

1. **LEDs don't light up**:
   - Verify pin assignments match your board
   - Check reset signal is high (or button released)
   - Verify clock is running

2. **Wrong pattern speed**:
   - Check clock frequency matches `CLK_FREQ` parameter
   - Verify clock constraints in SDC file

3. **Build errors**:
   - Ensure all files are in the same directory
   - Check FPGA part number matches your board
   - Verify Radiant version compatibility

## Next Steps

1. **Verify Pin Assignments**: Check your board schematic and update the PDC file
2. **Test Reset**: Connect RST_N to a button or tie high
3. **Modify Patterns**: Customize the LED patterns to your needs
4. **Add Features**: Consider adding pattern selection via switches or speed control