`timescale 1ns / 1ps

module ripple_carry_adder_tb;

    logic [3:0] a, b;
    logic       cin;
    logic [3:0] sum;
    logic       cout;

    int errors = 0;
    int tests  = 0;

    // Instantiate the DUT
    ripple_carry_adder dut (.*);

    task automatic check(logic [3:0] ta, tb, logic tcin);
        logic [4:0] expected;   // 5 bits: {cout, sum}

        a   = ta;
        b   = tb;
        cin = tcin;
        #10;

        expected = 5'(a) + 5'(b) + 5'(cin);
        tests++;

        if ({cout, sum} !== expected) begin
            errors++;
            $display("FAIL: a=%0d b=%0d cin=%b | sum=%0d cout=%b (expected sum=%0d cout=%b)",
                      a, b, cin, sum, cout, expected[3:0], expected[4]);
        end
    endtask

    initial begin
        $display("Starting Ripple Carry Adder Testbench (exhaustive, 512 cases)");

        for (int ai = 0; ai < 16; ai++) begin
            for (int bi = 0; bi < 16; bi++) begin
                for (int ci = 0; ci < 2; ci++) begin
                    check(ai[3:0], bi[3:0], ci[0]);
                end
            end
        end

        $display("\nRan %0d tests, %0d failed.", tests, errors);
        if (errors == 0)
            $display("All tests PASSED!");
        else
            $display("SOME TESTS FAILED.");

        $finish;
    end

endmodule
