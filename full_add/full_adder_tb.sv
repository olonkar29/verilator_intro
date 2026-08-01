`timescale 1ns / 1ps

module full_adder_tb;

    logic a, b, cin;
    logic sum, cout;
    int errors = 0;

    // Instantiate the DUT
    full_adder dut (.*);  // .* auto-connects ports with matching names

    // Task to check one test case
    task automatic check(logic ta, tb, tcin);
        logic exp_sum, exp_cout;
        {a, b, cin} = {ta, tb, tcin};
        #10;
        {exp_cout, exp_sum} = a + b + cin;

        if (sum !== exp_sum || cout !== exp_cout) begin
            errors++;
            $display("FAIL: a=%b b=%b cin=%b | sum=%b cout=%b (expected sum=%b cout=%b)",
                      a, b, cin, sum, cout, exp_sum, exp_cout);
        end else begin
            $display("PASS: a=%b b=%b cin=%b | sum=%b cout=%b",
                      a, b, cin, sum, cout);
        end
    endtask

    initial begin
        $display("Starting Full Adder Testbench");

        for (int i = 0; i < 8; i++) begin
            check(i[2], i[1], i[0]);
        end

        if (errors == 0)
            $display("\nAll tests PASSED!");
        else
            $display("\n%0d test(s) FAILED.", errors);

        $finish;
    end

endmodule
