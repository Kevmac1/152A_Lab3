module ucsbece152a_counter_tb;

    // Parameters
    parameter WIDTH = 3;

    // Create clock signal
    logic clk = 0;
    always #5 clk = ~clk; // flip `clk` every 5 timesteps to create a clock period of 10 timesteps

    // Instantiate counter signals
    logic rst;
    logic [WIDTH-1:0] count;
    logic en;
    logic dir;

    // Instantiate the "Design Under Test"
    ucsbece152a_counter #(
        .WIDTH(WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .count_o(count),
        .enable_i(en),
        .dir_i(dir)
    );

    // Simulation
    integer i;
    initial begin
        $display("Begin simulation.");

        // Initialize signals
        rst = 1;
        en = 0;
        dir = 0;
        @(negedge clk);

        // Release reset
        rst = 0;
        en = 1;

        // Count up to the maximum value
        for (i = 0; i < 2**WIDTH; i++) begin
            @(negedge clk);
            if (count != i) $display("Error at %0t: expected %0d, received %0d", $time, i, count);
        end

        // Check wrap-around from max to 0
        @(negedge clk);
        if (count != 0) $display("Error at %0t: expected %0d, received %0d", $time, 0, count);

        // Test reset
        rst = 1;
        @(negedge clk);
        if (count != 0) $display("Error at %0t: expected %0d, received %0d after reset", $time, 0, count);
        rst = 0;

        // Change direction to decrement
        dir = 1;
        // Count down from the maximum value
        for (i = (2**WIDTH)-1; i >= 0; i--) begin
            @(negedge clk);
            if (count != i) $display("Error at %0t: expected %0d, received %0d", $time, i, count);
        end

        // Check wrap-around from 0 to max
        @(negedge clk);
        if (count != (2**WIDTH)-1) $display("Error at %0t: expected %0d, received %0d", $time, (2**WIDTH)-1, count);

        // Enable low, counter should hold its value
        en = 0;
        @(negedge clk);
        if (count != (2**WIDTH)-1) $display("Error at %0t: expected %0d, received %0d with enable low", $time, (2**WIDTH)-1, count);

        // Re-enable and count down to check it resumes correctly
        en = 1;
        @(negedge clk);
        if (count != (2**WIDTH)-2) $display("Error at %0t: expected %0d, received %0d after re-enabling", $time, (2**WIDTH)-2, count);

        $display("End simulation.");
        $stop;
    end

endmodule
