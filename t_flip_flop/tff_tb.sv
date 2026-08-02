`timescale 1ns / 1ps

module tff_tb;

    logic t, reset, clk;
    logic q;
    int   errors = 0;

    // Instantiate the DUT
    tff dut (.*);  // .* auto-connects ports with matching names

    // Free-running clock: 10ns period
    always #5 clk = ~clk;

    // Reference model state
    logic exp_q;

    // Task: assert an asynchronous reset and check q goes to 0 immediately
    task automatic do_reset();
        reset = 1;
        #2;                     // async reset takes effect without waiting for clk
        exp_q = 1'b0;
        check_state("async reset");
        reset = 0;
    endtask

    // Task: drive t for one clock cycle, then check the resulting q
    task automatic step(logic tin);
        t = tin;
        @(posedge clk);
        #1;                     // let the nonblocking assignment settle
        exp_q = exp_q ^ tin;    // reference model: T-FF characteristic equation
        check_state($sformatf("t=%b", tin));
    endtask

    // Compare actual vs expected and report
    task automatic check_state(string label);
        if (q !== exp_q) begin
            errors++;
            $display("FAIL [%s] at time %0t: q=%b (expected %b)", label, $time, q, exp_q);
        end else begin
            $display("PASS [%s] at time %0t: q=%b", label, $time, q);
        end
    endtask

    initial begin
        $display("Starting T Flip-Flop Testbench");

        clk   = 0;
        t     = 0;
        reset = 0;

        // Test 1: async reset should win even with t=1 asserted
        t = 1;
        do_reset();

        // Test 2: hold behavior (t=0) for several cycles
        repeat (3) step(1'b0);

        // Test 3: toggle behavior (t=1) for several cycles
        repeat (6) step(1'b1);

        // Test 4: reset again mid-sequence, mid-toggle
        do_reset();

        // Test 5: resume toggling after reset, confirm normal operation
        repeat (4) step(1'b1);

        // Test 6: switch back to hold, confirm it freezes at current value (not 0)
        repeat (3) step(1'b0);

        if (errors == 0)
            $display("\nAll tests PASSED!");
        else
            $display("\n%0d test(s) FAILED.", errors);

        $finish;
    end

endmodule
