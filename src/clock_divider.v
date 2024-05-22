`default_nettype none   
`timescale 1ns/1ns 

module clock_divider (
    input wire clk, 
    output reg clk_slow
);

    reg [7:0] counter;
    reg top_bit;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end else begin
            counter <= counter + 1'b1;
            top_bit <= counter[7];
        end
    end

    assign clk_slow = top_bit;

endmodule 