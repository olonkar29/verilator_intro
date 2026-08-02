`timescale 1ns / 1ps

typedef enum  bit [1:0] {
    RED = 2'd0,
    YELLOW = 2'd1, 
    GREEN = 2'd2
} light_state;

module traffic_light (
    input logic clk,
    input logic rst,            // active-high, synchronous
    output light_state state
);

light_state next_state;
logic [3:0] timer;

 
counter c (.clk(clk), .rst_n(~rst), .en(1'b1), .count(timer)); // 4-bit, active-low synchronous reset counter

always_comb begin : next_state_calc
    next_state = state;
    if (timer == 4'b1111) begin
        case (state)
            RED: next_state = GREEN;
            GREEN: next_state = YELLOW;
            YELLOW: next_state = RED;
            default: next_state = RED;
        endcase
    end
end

always_ff @( posedge clk ) begin : blockName
    if (rst) begin
        state <= RED;
    end
    else begin
        state <= next_state;
    end
end
    
endmodule
