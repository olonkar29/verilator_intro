`timescale 1ns / 1ps

module counter_tb;

    logic       clk;
    logic       rst_n, en;
    logic [3:0] count;
    logic [3:0] exp_count;
    int errors = 0;

    // Instantiate the DUT
    counter dut (.*);  // .* auto-connects ports with matching names

    // Clock generator: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to apply one cycle of stimulus and check the result
    // after the clock edge that stimulus takes effect on.
    task automatic check(logic ten, logic trst_n, string label);
        en    = ten;
        rst_n = trst_n;

        @(posedge clk);
        #1; // let the non-blocking assignment settle

        // Reference model: same priority as the DUT (reset > enable > hold)
        if (!trst_n)
            exp_count = 4'b0;
        else if (ten)
            exp_count = exp_count + 1'b1;
        // else: hold, exp_count unchanged

        if (count !== exp_count) begin
            errors++;
            $display("FAIL [%s]: en=%b rst_n=%b | count=%b (expected %b)",
                      label, ten, trst_n, count, exp_count);
        end else begin
            $display("PASS [%s]: en=%b rst_n=%b | count=%b",
                      label, ten, trst_n, count);
        end
    endtask

    initial begin
        $display("Starting Counter Testbench");
        exp_count = 4'b0;
        en    = 0;
        rst_n = 0;

        check(0, 0, "reset");
        check(0, 0, "reset");
        check(0, 1, "hold");
        check(0, 1, "hold");

        for (int i = 0; i < 20; i++)
            check(1, 1, $sformatf("count[%0d]", i));

        check(0, 0, "mid-reset");
        check(1, 1, "resume");
        check(1, 1, "resume");
        check(1, 1, "resume");

        if (errors == 0)
            $display("\nAll tests PASSED!");
        else
            $display("\n%0d test(s) FAILED.", errors);

        $finish;
    end

endmodule
