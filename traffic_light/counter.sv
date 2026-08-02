`timescale 1ns / 1ps

module counter (
    input  logic       clk,
    input  logic       rst_n,   // active-low, synchronous
    input  logic       en,      // count enable
    output logic [3:0] count
);
    always_ff @( posedge clk ) begin : count_block
        if (!rst_n) begin
            count <= 4'b0;
        end
        else if (en) begin
            count <= count + 4'b1;
        end
        else begin
            count <= count;
        end
    end
endmodule
