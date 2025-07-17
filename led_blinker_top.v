`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Top-level wrapper for LED Blinker
// Maps FPGA pins to led_blinker module
//-----------------------------------------------------------------------------

module led_blinker_top (
    input  wire CLK,        // Clock input
    input  wire RST_N,      // Active low reset
    output wire LED12,      // LED outputs
    output wire LED13,
    output wire LED14,
    output wire LED15
);

    wire [3:0] led_bus;

    // Instantiate the LED blinker
    led_blinker led_blinker_inst (
        .clk(CLK),
        .rst_n(RST_N),
        .led(led_bus)
    );

    // Map led bus to individual LED pins
    assign LED12 = led_bus[0];
    assign LED13 = led_bus[1];
    assign LED14 = led_bus[2];
    assign LED15 = led_bus[3];

endmodule