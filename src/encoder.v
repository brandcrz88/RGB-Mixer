`default_nettype none
`timescale 1ns/1ns

module encoder #(
     parameter WIDTH = 8,
     parameter INCREMENT = 1'b1
    )
    (
     input wire a, 
     input wire b,
     input wire clk,
     input wire reset,
     output reg [WIDTH-1:0] value
    );

    reg old_a, old_b;

    always @(posedge clk) begin
	if (reset) begin
			value <= 0;
			old_a <= 0;
			old_b <= 0;
		end else begin
			old_a <= a; // these values are one clock behind
			old_b <= b;

			case({a, old_a, b, old_b})
				4'b1000 : value <= value + INCREMENT;
				4'b0111 : value <= value + INCREMENT;
				4'b0010 : value <= value - INCREMENT;
				4'b1101 : value <= value - INCREMENT;			
				default : value <= value; // no change in value otherwise		
			endcase //no default value
		end
    end

endmodule
