`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Testbench for LED Blinker
//-----------------------------------------------------------------------------

module led_blinker_tb;

    // Inputs
    reg clk;
    reg rst_n;
    
    // Outputs
    wire [3:0] led;
    
    // Instantiate the Unit Under Test (UUT)
    led_blinker uut (
        .clk(clk),
        .rst_n(rst_n),
        .led(led)
    );
    
    // Clock generation - 50 MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period = 50 MHz
    end
    
    // Test stimulus
    initial begin
        // Initialize
        rst_n = 0;
        
        // Wait and release reset
        #100;
        rst_n = 1;
        
        // Let it run for several pattern cycles
        // At 2 Hz, each pattern step takes 0.5 seconds
        // Run for 30 seconds to see multiple patterns
        #30_000_000_000; // 30 seconds in nanoseconds
        
        // Test reset during operation
        rst_n = 0;
        #100;
        rst_n = 1;
        
        // Run for another 10 seconds
        #10_000_000_000;
        
        $display("Testbench completed");
        $finish;
    end
    
    // Monitor LED changes
    always @(led) begin
        $display("Time=%0t: LED = %b", $time, led);
    end
    
    // Optional: Generate VCD file for waveform viewing
    initial begin
        $dumpfile("led_blinker_tb.vcd");
        $dumpvars(0, led_blinker_tb);
    end

endmodule