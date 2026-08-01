`timescale 1ns / 1ps

module priority_enc_tb;

    logic [3:0] in;
    logic [1:0] out;
    logic       valid;
    int errors = 0;

    // Instantiate the DUT
    priority_enc dut (.*);  // .* auto-connects ports with matching names

    // Task to check one test case
    task automatic check(logic [3:0] tin);
        logic [1:0] exp_out;
        logic       exp_valid;
        in = tin;
        #10;

        // Reference model: index of highest set bit, valid=0 if none set
        exp_out   = 2'd0;
        exp_valid = 1'b1;
        if (in[0]) exp_out = 2'd0;
        if (in[1]) exp_out = 2'd1;
        if (in[2]) exp_out = 2'd2;
        if (in[3]) exp_out = 2'd3;
        if (in == 4'b0000) exp_valid = 1'b0;

        if (out !== exp_out || valid !== exp_valid) begin
            errors++;
            $display("FAIL: in=%b | out=%b valid=%b (expected out=%b valid=%b)",
                      in, out, valid, exp_out, exp_valid);
        end else begin
            $display("PASS: in=%b | out=%b valid=%b",
                      in, out, valid);
        end
    endtask

    initial begin
        $display("Starting Priority Encoder Testbench");

        for (int i = 0; i < 16; i++) begin
            check(i[3:0]);
        end

        if (errors == 0)
            $display("\nAll tests PASSED!");
        else
            $display("\n%0d test(s) FAILED.", errors);

        $finish;
    end

endmodule
