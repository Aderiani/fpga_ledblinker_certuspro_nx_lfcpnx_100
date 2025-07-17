`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Test all possible LED outputs
// Toggles multiple pins to find the actual LED connections
//-----------------------------------------------------------------------------

module simple_led_blinker (
    input  wire       RST_N,      // Active low reset
    output wire       LED12,      // LED outputs  
    output wire       LED13,
    output wire       LED14,
    output wire       LED15
);

    // Internal oscillator output
    wire osc_clk;
    
    // Counter for creating slow blink
    reg [28:0] counter = 0;
    
    // Toggle signal
    reg toggle = 0;
    
    // Instantiate internal oscillator
    OSCA osc_inst (
        .HFOUTEN(1'b1),
        .HFCLKOUT(osc_clk),
        .LFCLKOUT()
    );
    
    // Main counter
    always @(posedge osc_clk or negedge RST_N) begin
        if (!RST_N) begin
            counter <= 0;
            toggle <= 0;
        end else begin
            counter <= counter + 1;
            
            // Toggle all LEDs every ~0.6 seconds
            // 450 MHz / 2^28 ≈ 1.68 Hz
            if (counter == 29'h0FFFFFFF) begin
                toggle <= ~toggle;
            end
        end
    end
    
    // All LEDs follow the same pattern for testing
    assign LED12 = toggle;
    assign LED13 = toggle;
    assign LED14 = toggle;
    assign LED15 = toggle;

endmodule