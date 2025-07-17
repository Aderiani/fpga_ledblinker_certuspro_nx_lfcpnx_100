`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// LED Pattern Blinker for CertusPro-NX FPGA
// This module creates various LED patterns on 4 LEDs
// Designed for GR740-MINI board with 50MHz input clock
//-----------------------------------------------------------------------------

module led_blinker (
    input  wire       clk,          // Input clock
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
    reg direction = 0;  // For knight rider pattern

    // Clock divider - generates enable pulse at BLINK_FREQ
    always @(posedge clk or negedge rst_n) begin
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
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led <= 4'b0000;
            pattern_state <= 0;
            pattern_counter <= 0;
            direction <= 0;
        end else if (clk_enable) begin
            case (pattern_state)
                // Pattern 0: Binary counter (0000 to 1111)
                3'd0: begin
                    led <= pattern_counter;
                    if (pattern_counter == 4'b1111) begin
                        pattern_counter <= 0;
                        pattern_state <= pattern_state + 1;
                    end else begin
                        pattern_counter <= pattern_counter + 1;
                    end
                end
                
                // Pattern 1: Knight Rider (back and forth)
                3'd1: begin
                    case (pattern_counter[1:0])
                        2'b00: led <= 4'b0001;
                        2'b01: led <= 4'b0010;
                        2'b10: led <= 4'b0100;
                        2'b11: led <= 4'b1000;
                    endcase
                    
                    if (direction == 0) begin
                        if (pattern_counter == 3) begin
                            direction <= 1;
                        end else begin
                            pattern_counter <= pattern_counter + 1;
                        end
                    end else begin
                        if (pattern_counter == 0) begin
                            direction <= 0;
                            pattern_state <= pattern_state + 1;
                        end else begin
                            pattern_counter <= pattern_counter - 1;
                        end
                    end
                end
                
                // Pattern 2: Fill and empty
                3'd2: begin
                    case (pattern_counter[2:0])
                        3'd0: led <= 4'b0000;
                        3'd1: led <= 4'b0001;
                        3'd2: led <= 4'b0011;
                        3'd3: led <= 4'b0111;
                        3'd4: led <= 4'b1111;
                        3'd5: led <= 4'b0111;
                        3'd6: led <= 4'b0011;
                        3'd7: led <= 4'b0001;
                    endcase
                    
                    if (pattern_counter == 7) begin
                        pattern_counter <= 0;
                        pattern_state <= pattern_state + 1;
                    end else begin
                        pattern_counter <= pattern_counter + 1;
                    end
                end
                
                // Pattern 3: Alternating pairs
                3'd3: begin
                    led <= (pattern_counter[0]) ? 4'b1010 : 4'b0101;
                    if (pattern_counter == 7) begin
                        pattern_counter <= 0;
                        pattern_state <= pattern_state + 1;
                    end else begin
                        pattern_counter <= pattern_counter + 1;
                    end
                end
                
                // Pattern 4: All blink
                3'd4: begin
                    led <= (pattern_counter[0]) ? 4'b1111 : 4'b0000;
                    if (pattern_counter == 7) begin
                        pattern_counter <= 0;
                        pattern_state <= 0;  // Loop back to start
                    end else begin
                        pattern_counter <= pattern_counter + 1;
                    end
                end
                
                default: begin
                    pattern_state <= 0;
                    pattern_counter <= 0;
                end
            endcase
        end
    end

endmodule