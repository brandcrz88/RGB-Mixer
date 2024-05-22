`default_nettype none
`timescale 1ns/1ns

module rgb_mixer (
    input clk,
    input reset,
    input enc0_a,
    input enc0_b,
    input enc1_a,
    input enc1_b,
    input enc2_a,
    input enc2_b,
    output pwm0_out,
    output pwm1_out,
    output pwm2_out
);
    wire enc0_a_db, enc0_b_db;
    wire enc1_a_db, enc1_b_db;
    wire enc2_a_db, enc2_b_db;
    wire [7:0] enc0, enc1, enc2;
    wire new_clk;

    clock_divider clock_slow(.clk(clk), .clk_slow(new_clk));

    // debouncers, 2 for each encoder
    debounce #(.HIST_LEN(8)) debounce0_a(.clk(new_clk), .reset(reset), .button(enc0_a), .debounced(enc0_a_db));
    debounce #(.HIST_LEN(8)) debounce0_b(.clk(new_clk), .reset(reset), .button(enc0_b), .debounced(enc0_b_db));

    debounce #(.HIST_LEN(8)) debounce1_a(.clk(new_clk), .reset(reset), .button(enc1_a), .debounced(enc1_a_db));
    debounce #(.HIST_LEN(8)) debounce1_b(.clk(new_clk), .reset(reset), .button(enc1_b), .debounced(enc1_b_db));

    debounce #(.HIST_LEN(8)) debounce2_a(.clk(new_clk), .reset(reset), .button(enc2_a), .debounced(enc2_a_db));
    debounce #(.HIST_LEN(8)) debounce2_b(.clk(new_clk), .reset(reset), .button(enc2_b), .debounced(enc2_b_db));

    // encoders
    encoder #(.WIDTH(8)) encoder0(.clk(new_clk), .reset(reset), .a(enc0_a_db), .b(enc0_b_db), .value(enc0));
    encoder #(.WIDTH(8)) encoder1(.clk(new_clk), .reset(reset), .a(enc1_a_db), .b(enc1_b_db), .value(enc1));
    encoder #(.WIDTH(8)) encoder2(.clk(new_clk), .reset(reset), .a(enc2_a_db), .b(enc2_b_db), .value(enc2));

    // pwm modules
    pwm #(.WIDTH(8)) pwm0(.clk(new_clk), .reset(reset), .out(pwm0_out), .level(enc0));
    pwm #(.WIDTH(8)) pwm1(.clk(new_clk), .reset(reset), .out(pwm1_out), .level(enc1));
    pwm #(.WIDTH(8)) pwm2(.clk(new_clk), .reset(reset), .out(pwm2_out), .level(enc2));

endmodule

module clock_divider(
    input clk,
    output reg clk_slow
);
    reg [7:0] counter;
    reg top_bit;

    always @(posedge clk) begin
        counter <= counter + 1'b1;
        top_bit <= counter[7];
        clk_slow <= top_bit;
    end
endmodule

module debounce #(
    parameter HIST_LEN = 8
)( 
    input wire reset,
    input wire clk,
    input wire button,
    output reg debounced
);
    localparam on_value = 2 ** HIST_LEN - 1;
    reg [HIST_LEN-1:0] button_hist;

    always @(posedge clk) begin
        if (reset) begin
            button_hist <= 0;
            debounced <= 1'b0;
        end else begin
            button_hist <= {button_hist[HIST_LEN-2:0], button};
            if (button_hist == on_value)
                debounced <= 1'b1;
            else if (button_hist == {HIST_LEN{1'b0}})
                debounced <= 1'b0;
        end
    end 
endmodule 

module encoder #(
    parameter WIDTH = 8,
    parameter INCREMENT = 1'b1
)(
    input wire clk,
    input wire reset,
    input wire a,
    input wire b,
    output reg [WIDTH-1:0] value
);
    reg old_a, old_b;

    always @(posedge clk) begin
        if (reset) begin
            value <= 0;
            old_a <= 0;
            old_b <= 0;
        end else begin
            old_a <= a;
            old_b <= b;
            case ({a, old_a, b, old_b})
                4'b1000, 4'b0111: value <= value + INCREMENT;
                4'b0010, 4'b1101: value <= value - INCREMENT;
                default: value <= value;
            endcase
        end
    end
endmodule

module pwm #(
    parameter WIDTH = 8,
    parameter INVERT = 0
)(
    input wire clk,
    input wire reset,
    output wire out,
    input wire [WIDTH-1:0] level
);
    reg [WIDTH-1:0] counter;
    wire pwm_on = counter < level;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    assign out = reset ? 1'b0 :
                 (INVERT == 1'b0 ? pwm_on : !pwm_on);
endmodule
