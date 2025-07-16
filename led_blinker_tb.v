`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Testbench for LED Pattern Blinker
// Simulates the LED patterns at accelerated speed
//-----------------------------------------------------------------------------

module led_blinker_tb;

    // Testbench signals
    reg         clk_50mhz;
    reg         rst_n;
    wire  [3:0] led;
    
    // Parameters for faster simulation
    parameter CLK_PERIOD = 20;          // 20ns = 50MHz
    parameter SIM_SPEEDUP = 1000;       // Speed up simulation by 1000x
    
    // Instantiate DUT with modified parameters for simulation
    led_blinker #(
        .CLK_FREQ(50_000_000),
        .BLINK_FREQ(2000)               // 2000 Hz instead of 2 Hz for simulation
    ) dut (
        .clk_50mhz  (clk_50mhz),
        .rst_n      (rst_n),
        .led        (led)
    );
    
    // Clock generation
    initial begin
        clk_50mhz = 0;
        forever #(CLK_PERIOD/2) clk_50mhz = ~clk_50mhz;
    end
    
    // Test stimulus
    initial begin
        // Initialize
        rst_n = 0;
        
        // Create VCD file for waveform viewing
        $dumpfile("led_blinker_tb.vcd");
        $dumpvars(0, led_blinker_tb);
        
        // Display header
        $display("Time\t\tReset\tLED[3:0]\tPattern");
        $display("----\t\t-----\t--------\t-------");
        
        // Reset sequence
        #(CLK_PERIOD * 10) rst_n = 1;
        $display("%0t\t%b\t%b\tReset released", $time, rst_n, led);
        
        // Monitor LED changes
        $monitor("%0t\t%b\t%b", $time, rst_n, led);
        
        // Run simulation for enough time to see all patterns
        // Each pattern takes different amounts of time
        #(CLK_PERIOD * 100000);
        
        $display("Simulation completed!");
        $finish;
    end
    
    // Pattern detector for display
    reg [2:0] detected_pattern;
    always @(led) begin
        case (dut.pattern_state)
            3'd0: $display("Pattern: Binary Counter - LED = %b", led);
            3'd1: $display("Pattern: Knight Rider - LED = %b", led);
            3'd2: $display("Pattern: Fill and Empty - LED = %b", led);
            3'd3: $display("Pattern: Alternating Pairs - LED = %b", led);
            3'd4: $display("Pattern: All Blink - LED = %b", led);
        endcase
    end

endmodule