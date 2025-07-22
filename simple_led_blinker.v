`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Simple LED Test for GR740-MINI
// All LEDs blink together at a visible rate
//-----------------------------------------------------------------------------

module simple_led_test (
    input  wire       gsrn,     // Global Set/Reset (active low)
    output reg  [3:0] led       // LED outputs [LED15:LED12]
);

    // Internal oscillator output
    wire osc_clk;
    
    // Counter for creating slow blink
    reg [27:0] counter = 0;
    
    // Instantiate internal oscillator
    OSCA osc_inst (
        .HFOUTEN(1'b1),
        .HFCLKOUT(osc_clk),
        .LFCLKOUT()
    );
    
    // Simple blink logic
    always @(posedge osc_clk or negedge gsrn) begin
        if (!gsrn) begin
            counter <= 0;
            led <= 4'b0000;
        end else begin
            counter <= counter + 1;
            
            // Toggle all LEDs together every ~0.75 seconds
            // 450 MHz / 2^28 ≈ 1.68 Hz
            if (counter[27]) begin
                led <= 4'b1111;  // All LEDs on
            end else begin
                led <= 4'b0000;  // All LEDs off
            end
        end
    end

endmodule