// This module defines a PWM
`default_nettype none
`timescale 1ns/1ns

module pwm #(
    parameter INVERT = 0, // Signal is not inverted so that means that the signal is active high
    parameter WIDTH = 8
    )(
    // Ports are defined here
    input wire clk,
    input wire reset,
    output wire out,
    input wire [WIDTH-1:0] level
    );

    reg [WIDTH-1:0] counter;

    wire pwm_on = counter < level; // implicit assign

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end else begin
            counter <= counter + 1'b1; // specify bit wide to avoid 32 bit assign from yosys
        end
    end

    assign out = reset ? 1'b0 :
        INVERT == 1'b0 ? pwm_on : !pwm_on;
    
endmodule