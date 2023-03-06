`default_nettype none
`timescale 1ns/1ns
module debounce (
    input wire clk,
    input wire reset,
    input wire button,
    output reg debounced
);

	reg [7:0] history;
	
	always @(posedge clk) begin
		if (reset) begin
			history <= 0;
		end else begin
			history <= { history[6:0], button };
			if (history == 8'b1111_1111)
				debounced <= 1;
				
			if (history == 8'b0000_0000)
				debounced <= 0;
		end
	end

endmodule
