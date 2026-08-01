`timescale 1ns / 1ps

module ripple_carry_adder (
	input logic [3:0] a, b,
	input logic cin,
	output logic [3:0] sum,
	output logic cout
);

	logic [4:0] carry;
	assign carry[0] = cin;
	assign cout = carry[4];

	genvar i;

	generate
		for (i = 0; i < 4; i++) begin : gen_full_add
			full_adder fa(.a(a[i]), .b(b[i]), .cin(carry[i]), .sum(sum[i]), .cout(carry[i+1]));
		end
	endgenerate
	

endmodule
