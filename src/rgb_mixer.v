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
	reg [7:0] counter; /* general clock counter */

	reg [7:0] debounceReg_0_a; /* shift reg for enc0 pin A */
	reg [7:0] debounceReg_0_b; /* shift reg for enc0 pin B */
	reg deb_0_a; /* current debounced value for enc0 pin A */
	reg deb_0_b; /* current debounced value for enc0 pin B */
	reg deb_old_0_a; /* old debounced value for enc0 pin A */
	reg deb_old_0_b; /* old debounced value for enc0 pin B */
	reg [7:0] enc0; /* current value of encoder 0 register */

	reg [7:0] debounceReg_1_a;
	reg [7:0] debounceReg_1_b;
	reg deb_1_a;
	reg deb_1_b;
	reg deb_old_1_a;
	reg deb_old_1_b;
	reg [7:0] enc1;
	
	reg [7:0] debounceReg_2_a;	
	reg [7:0] debounceReg_2_b;
	reg deb_2_a;
	reg deb_2_b;
	reg deb_old_2_a;
	reg deb_old_2_b;
	reg [7:0] enc2;
	
	always @(posedge clk) begin
		if (reset) begin
			counter <= 0;
		
			enc0 <= 0;
			enc1 <= 0;
			enc2 <= 0;
						
			debounceReg_0_a <= 0;
			debounceReg_0_b <= 0;
			debounceReg_1_a <= 0;			
			debounceReg_1_b <= 0;
			debounceReg_2_a <= 0;
			debounceReg_2_b <= 0;

			deb_0_a <= 0;
			deb_0_b <= 0;
			deb_1_a <= 0;
			deb_1_b <= 0;
			deb_2_a <= 0;
			deb_2_b <= 0;
		
			deb_old_0_a <= 0;
			deb_old_0_b <= 0;
			deb_old_1_a <= 0;
			deb_old_1_b <= 0;
			deb_old_2_a <= 0;
			deb_old_2_b <= 0;										

		end else begin
			counter <= counter + 1'b1;
		
			/* Debouncing inputs */
			debounceReg_0_a <= { debounceReg_0_a[6:0], enc0_a };
			debounceReg_0_b <= { debounceReg_0_b[6:0], enc0_b };
			
			if (debounceReg_0_a == 8'b0000_0000) begin
				deb_0_a <= 0;
			end else begin
				deb_0_a <= 1;
			end
			
			if (debounceReg_0_b == 8'b0000_0000) begin
				deb_0_b <= 0;
			end else begin
				deb_0_b <= 1;
			end
			
			
			debounceReg_1_a <= { debounceReg_1_a[6:0], enc1_a };		
			debounceReg_1_b <= { debounceReg_1_b[6:0], enc1_b };
			
			if (debounceReg_1_a == 8'b0000_0000) begin
				deb_1_a <= 0;
			end else begin
				deb_1_a <= 1;
			end
			
			if (debounceReg_1_b == 8'b0000_0000) begin
				deb_1_b <= 0;
			end else begin
				deb_1_b <= 1;
			end	
					
			debounceReg_2_b <= { debounceReg_2_b[6:0], enc2_b };	
			debounceReg_2_a <= { debounceReg_2_a[6:0], enc2_a };

			if (debounceReg_2_a == 8'b0000_0000) begin
				deb_2_a <= 0;
			end else begin
				deb_2_a <= 1;
			end
			
			if (debounceReg_2_b == 8'b0000_0000) begin
				deb_2_b <= 0;
			end else begin
				deb_2_b <= 1;
			end
			
			if ({deb_0_a, deb_old_0_a, deb_0_b, deb_old_0_b} == 4'b1000) enc0 = enc0 + 1'b1;
			if ({deb_0_a, deb_old_0_a, deb_0_b, deb_old_0_b} == 4'b0111) enc0 = enc0 + 1'b1;			
			if ({deb_0_a, deb_old_0_a, deb_0_b, deb_old_0_b} == 4'b0010) enc0 = enc0 - 1'b1;
			if ({deb_0_a, deb_old_0_a, deb_0_b, deb_old_0_b} == 4'b1101) enc0 = enc0 - 1'b1;			
			
			if ({deb_1_a, deb_old_1_a, deb_1_b, deb_old_1_b} == 4'b1000) enc1 = enc1 + 1'b1;
			if ({deb_1_a, deb_old_1_a, deb_1_b, deb_old_1_b} == 4'b0111) enc1 = enc1 + 1'b1;			
			if ({deb_1_a, deb_old_1_a, deb_1_b, deb_old_1_b} == 4'b0010) enc1 = enc1 - 1'b1;
			if ({deb_1_a, deb_old_1_a, deb_1_b, deb_old_1_b} == 4'b1101) enc1 = enc1 - 1'b1;
			
			if ({deb_2_a, deb_old_2_a, deb_2_b, deb_old_2_b} == 4'b1000) enc2 = enc2 + 1'b1;
			if ({deb_2_a, deb_old_2_a, deb_2_b, deb_old_2_b} == 4'b0111) enc2 = enc2 + 1'b1;			
			if ({deb_2_a, deb_old_2_a, deb_2_b, deb_old_2_b} == 4'b0010) enc2 = enc2 - 1'b1;
			if ({deb_2_a, deb_old_2_a, deb_2_b, deb_old_2_b} == 4'b1101) enc2 = enc2 - 1'b1;							
			
			deb_old_0_a <= deb_0_a;
			deb_old_0_b <= deb_0_b;
			
			deb_old_1_a <= deb_1_a;
			deb_old_1_b <= deb_1_b;
			
			deb_old_2_a <= deb_2_a;
			deb_old_2_b <= deb_2_b;
		end
	end

	assign pwm0_out = counter < enc0;
	assign pwm1_out = counter < enc1;
	assign pwm2_out = counter < enc2;

endmodule
