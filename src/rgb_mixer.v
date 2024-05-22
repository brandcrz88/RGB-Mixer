`default_nettype none   
`timescale 1ns/1ns

module rgb_mixer (
    input wire clk,
    input wire reset,
    input wire enc0_a,
    input wire enc0_b,
    input wire enc1_a,
    input wire enc1_b,
    input wire enc2_a,
    input wire enc2_b,
    output wire pwm0_out,
    output wire pwm1_out,
    output wire pwm2_out
);

    wire enc0_a_db, enc0_b_db;
    wire enc1_a_db, enc1_b_db;
    wire enc2_a_db, enc2_b_db;
    wire [7:0] enc0, enc1, enc2;

    // debouncers, 2 for each channel (RGB)
    debounce #(.HIST_LEN(8)) debounce0_a(.clk(clk), .reset(reset), .button(enc0_a), .debounced(enc0_a_db));
    debounce #(.HIST_LEN(8)) debounce0_b(.clk(clk), .reset(reset), .button(enc0_b), .debounced(enc0_b_db));
    debounce #(.HIST_LEN(8)) debounce1_a(.clk(clk), .reset(reset), .button(enc1_a), .debounced(enc1_a_db));
    debounce #(.HIST_LEN(8)) debounce1_b(.clk(clk), .reset(reset), .button(enc1_b), .debounced(enc1_b_db));
    debounce #(.HIST_LEN(8)) debounce2_a(.clk(clk), .reset(reset), .button(enc2_a), .debounced(enc2_a_db));
    debounce #(.HIST_LEN(8)) debounce2_b(.clk(clk), .reset(reset), .button(enc2_b), .debounced(enc2_b_db));

    // Connecting the debounced signals to the encoders
    encoder #(.WIDTH(8)) encoder0 (.clk(clk), .reset(reset), .a(enc0_a_db), .b(enc0_b_db), .value(enc0));
    encoder #(.WIDTH(8)) encoder1 (.clk(clk), .reset(reset), .a(enc1_a_db), .b(enc1_b_db), .value(enc1));
    encoder #(.WIDTH(8)) encoder2 (.clk(clk), .reset(reset), .a(enc2_a_db), .b(enc2_b_db), .value(enc2));

    // Sending value to PWM to set the value at which the signal is going to be modulated
    pwm #(.WIDTH(8)) pwm0 (.clk(clk), .reset(reset), .level(enc0), .out(pwm0_out));
    pwm #(.WIDTH(8)) pwm1 (.clk(clk), .reset(reset), .level(enc1), .out(pwm1_out));
    pwm #(.WIDTH(8)) pwm2 (.clk(clk), .reset(reset), .level(enc2), .out(pwm2_out));


endmodule