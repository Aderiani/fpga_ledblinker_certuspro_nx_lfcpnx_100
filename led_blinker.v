`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// LED Pattern Blinker for CertusPro-NX FPGA
// This module creates various LED patterns on 4 LEDs
// Designed for GR740-MINI board with 50MHz input clock
//-----------------------------------------------------------------------------

module led_blinker (
    input  wire       clk_50mhz,    // 50 MHz input clock
    input  wire       rst_n,        // Active low reset
    output reg  [3:0] led           // LED outputs [LED15:LED12]
);

    // Clock divider parameters
    parameter CLK_FREQ = 50_000_000;    // 50 MHz
    parameter BLINK_FREQ = 2;           // 2 Hz for pattern changes
    parameter CNT_MAX = CLK_FREQ / BLINK_FREQ / 2;

    // Counter for clock division
    reg [24:0] clk_counter = 0;
    reg clk_enable = 0;

    // Pattern state machine
    reg [2:0] pattern_state = 0;
    reg [3:0] pattern_counter = 0;

    // Clock divider - generates enable pulse at BLINK_FREQ
    always @(posedge clk_50mhz or negedge rst_n) begin
        if (!rst_n) begin
            clk_counter <= 0;
            clk_enable <= 0;
        end else begin
            if (clk_counter >= CNT_MAX - 1) begin
                clk_counter <= 0;
                clk_enable <= 1;
            end else begin
                clk_counter <= clk_counter + 1;
                clk_enable <= 0;
            end
        end
    end

    // LED pattern generator
    always @(posedge clk_50mhz or negedge rst_n) begin
        if (!rst_n) begin
            led <= 4'b0000;
            pattern_state <= 0;
            pattern_counter <= 0;
        end else if (clk_enable) begin
            case (pattern_state)
                // Pattern 0: Binary counter
                3'd0: begin
                    led <= pattern_counter;
                    pattern_counter <= pattern_counter + 1;
                    if (pattern_counter == 4'b1111) begin
                        pattern_state <= 3'd1;
                        pattern_counter <= 0;
                    end
                end
                
                // Pattern 1: Knight Rider (left to right and back)
                3'd1: begin
                    case (pattern_counter)
                        4'd0: led <= 4'b0001;
                        4'd1: led <= 4'b0010;
                        4'd2: led <= 4'b0100;
                        4'd3: led <= 4'b1000;
                        4'd4: led <= 4'b0100;
                        4'd5: led <= 4'b0010;
                        4'd6: led <= 4'b0001;
                        default: led <= 4'b0001;
                    endcase
                    
                    if (pattern_counter >= 6) begin
                        pattern_counter <= 0;
                        if (led == 4'b0001) begin
                            pattern_state <= 3'd2;
                        end
                    end else begin
                        pattern_counter <= pattern_counter + 1;
                    end
                end
                
                // Pattern 2: Fill and empty
                3'd2: begin
                    case (pattern_counter)
                        4'd0: led <= 4'b0000;
                        4'd1: led <= 4'b0001;
                        4'd2: led <= 4'b0011;
                        4'd3: led <= 4'b0111;
                        4'd4: led <= 4'b1111;
                        4'd5: led <= 4'b1110;
                        4'd6: led <= 4'b1100;
                        4'd7: led <= 4'b1000;
                        4'd8: led <= 4'b0000;
                        default: led <= 4'b0000;
                    endcase
                    
                    pattern_counter <= pattern_counter + 1;
                    if (pattern_counter >= 8) begin
                        pattern_counter <= 0;
                        pattern_state <= 3'd3;
                    end
                end
                
                // Pattern 3: Alternating pairs
                3'd3: begin
                    if (pattern_counter[0])
                        led <= 4'b1010;
                    else
                        led <= 4'b0101;
                    
                    pattern_counter <= pattern_counter + 1;
                    if (pattern_counter >= 7) begin
                        pattern_counter <= 0;
                        pattern_state <= 3'd4;
                    end
                end
                
                // Pattern 4: All on/off blink
                3'd4: begin
                    if (pattern_counter[0])
                        led <= 4'b1111;
                    else
                        led <= 4'b0000;
                    
                    pattern_counter <= pattern_counter + 1;
                    if (pattern_counter >= 7) begin
                        pattern_counter <= 0;
                        pattern_state <= 3'd0; // Loop back to beginning
                    end
                end
                
                default: begin
                    pattern_state <= 3'd0;
                    pattern_counter <= 0;
                    led <= 4'b0000;
                end
            endcase
        end
    end

endmodule