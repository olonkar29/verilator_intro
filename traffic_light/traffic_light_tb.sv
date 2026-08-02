`timescale 1ns / 1ps

module traffic_light_tb;

    logic       clk;
    logic       rst;
    light_state state;
    light_state exp_state;
    logic [3:0] exp_timer;
    int errors = 0;

    // Instantiate the DUT
    traffic_light dut (.*);  // .* auto-connects ports with matching names

    // Clock generator: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to apply one cycle of stimulus and check the result
    // after the clock edge that stimulus takes effect on.
    task automatic check(logic trst, string label);
        light_state state_next;
        logic [3:0] timer_next;

        rst = trst;

        // Reference model: compute next values from CURRENT (pre-edge)
        // exp_state/exp_timer, mirroring the DUT's combinational logic.
        if (exp_timer == 4'hF) begin
            case (exp_state)
                RED:     state_next = GREEN;
                GREEN:   state_next = YELLOW;
                YELLOW:  state_next = RED;
                default: state_next = RED;
            endcase
        end else begin
            state_next = exp_state;
        end
        timer_next = exp_timer + 1'b1;

        @(posedge clk);
        #1; // let the non-blocking assignments settle

        // Reference model: same reset priority as the DUT (state and
        // counter share the same rst, both synchronous)
        if (trst) begin
            exp_state = RED;
            exp_timer = 4'b0;
        end else begin
            exp_state = state_next;
            exp_timer = timer_next;
        end

        if (state !== exp_state) begin
            errors++;
            $display("FAIL [%s]: rst=%b | state=%s (expected %s) timer=%0d",
                      label, trst, state.name(), exp_state.name(), dut.timer);
        end else if (dut.timer !== exp_timer) begin
            errors++;
            $display("FAIL [%s]: rst=%b | timer=%0d (expected %0d) state=%s",
                      label, trst, dut.timer, exp_timer, state.name());
        end else begin
            $display("PASS [%s]: rst=%b | state=%s timer=%0d",
                      label, trst, state.name(), dut.timer);
        end
    endtask

    initial begin
        $display("Starting Traffic Light Testbench");
        exp_state = RED;
        exp_timer = 4'b0;
        rst = 1;

        check(1, "reset");
        check(1, "reset");
        check(1, "reset");

        // Release reset, run through 3 full RED->GREEN->YELLOW->RED
        // cycles (16 clocks/state x 3 states x 3 laps = 144 checks)
        for (int lap = 0; lap < 3; lap++) begin
            for (int i = 0; i < 16; i++)
                check(0, $sformatf("lap%0d_RED[%0d]", lap, i));
            for (int i = 0; i < 16; i++)
                check(0, $sformatf("lap%0d_GREEN[%0d]", lap, i));
            for (int i = 0; i < 16; i++)
                check(0, $sformatf("lap%0d_YELLOW[%0d]", lap, i));
        end

        // Mid-run reset, verify it resynchronizes state and timer together
        check(1, "mid-reset");
        check(1, "mid-reset");
        for (int i = 0; i < 16; i++)
            check(0, $sformatf("resume_RED[%0d]", i));
        for (int i = 0; i < 5; i++)
            check(0, $sformatf("resume_GREEN[%0d]", i));

        if (errors == 0)
            $display("\nAll tests PASSED!");
        else
            $display("\n%0d test(s) FAILED.", errors);

        $finish;
    end

endmodule
