`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// On-Board LED Blinker for GR740-MINI
// Uses internal oscillator to blink the on-board LEDs
//-----------------------------------------------------------------------------

module onboard_led_blinker (
    input  wire       gsrn,     // Global Set/Reset (active low) - from constraint file
    output wire [3:0] led       // LED outputs [LED15:LED12]
);

    // Internal oscillator output
    wire osc_clk;
    
    // Counter for creating slow blink
    reg [27:0] counter = 0;
    
    // Pattern state machine
    reg [2:0] pattern_state = 0;
    reg [3:0] pattern_counter = 0;
    reg [3:0] led_reg = 4'b0001;
    reg direction = 0;
    
    // Instantiate internal oscillator
    // CertusPro-NX has a 450 MHz HF oscillator
    OSCA osc_inst (
        .HFOUTEN(1'b1),          // Enable HF output
        .HFCLKOUT(osc_clk),      // HF clock output
        .LFCLKOUT()              // LF clock output (not used)
    );
    
    // Main counter and pattern control
    always @(posedge osc_clk or negedge gsrn) begin
        if (!gsrn) begin
            counter <= 0;
            pattern_state <= 0;
            pattern_counter <= 0;
            led_reg <= 4'b0001;
            direction <= 0;
        end else begin
            counter <= counter + 1;
            
            // Change pattern every ~0.3 seconds for visibility
            // 450 MHz / 2^27 ≈ 3.35 Hz
            if (counter == 28'h8FFFFFF) begin
                counter <= 0;
                
                case (pattern_state)
                    // Pattern 0: Binary counter
                    3'd0: begin
                        led_reg <= pattern_counter;
                        if (pattern_counter == 4'b1111) begin
                            pattern_counter <= 0;
                            pattern_state <= pattern_state + 1;
                        end else begin
                            pattern_counter <= pattern_counter + 1;
                        end
                    end
                    
                    // Pattern 1: Knight Rider
                    3'd1: begin
                        case (pattern_counter[1:0])
                            2'b00: led_reg <= 4'b0001;
                            2'b01: led_reg <= 4'b0010;
                            2'b10: led_reg <= 4'b0100;
                            2'b11: led_reg <= 4'b1000;
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
                            3'd0: led_reg <= 4'b0000;
                            3'd1: led_reg <= 4'b0001;
                            3'd2: led_reg <= 4'b0011;
                            3'd3: led_reg <= 4'b0111;
                            3'd4: led_reg <= 4'b1111;
                            3'd5: led_reg <= 4'b0111;
                            3'd6: led_reg <= 4'b0011;
                            3'd7: led_reg <= 4'b0001;
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
                        led_reg <= (pattern_counter[0]) ? 4'b1010 : 4'b0101;
                        if (pattern_counter == 7) begin
                            pattern_counter <= 0;
                            pattern_state <= pattern_state + 1;
                        end else begin
                            pattern_counter <= pattern_counter + 1;
                        end
                    end
                    
                    // Pattern 4: All blink
                    3'd4: begin
                        led_reg <= (pattern_counter[0]) ? 4'b1111 : 4'b0000;
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
                        led_reg <= 4'b0001;
                    end
                endcase
            end
        end
    end
    
    // Assign outputs
    assign led = led_reg;

endmodule