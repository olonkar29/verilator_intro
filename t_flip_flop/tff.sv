`timescale 1ns / 1ps

module tff (
    input logic t,
    input logic reset,
    input logic clk,
    output logic q
);

always_ff @( posedge clk or posedge reset ) begin : t_ff
    if (reset) begin
        q <= 1'b0;
    end
    else begin
        q <= t ^ q;
    end
end
    
endmodule
