`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Top level wrapper for LED blinker
// Includes I/O buffer instantiations for CertusPro-NX
//-----------------------------------------------------------------------------

module led_blinker_top (
    input  wire       CLK_50MHZ,    // 50 MHz clock input
    input  wire       RST_N,        // Active low reset (could be a button)
    output wire       LED12,        // LED outputs
    output wire       LED13,
    output wire       LED14,
    output wire       LED15
);

    // Internal signals
    wire [3:0] led_internal;
    
    // Main LED blinker instance
    led_blinker u_led_blinker (
        .clk_50mhz  (CLK_50MHZ),
        .rst_n      (RST_N),
        .led        (led_internal)
    );
    
    // Assign individual LED outputs
    assign LED12 = led_internal[0];
    assign LED13 = led_internal[1];
    assign LED14 = led_internal[2];
    assign LED15 = led_internal[3];

endmodule