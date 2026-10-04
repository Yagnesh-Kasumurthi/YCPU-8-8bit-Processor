
module program_counter_tb;

    reg clk;
    reg reset;
    reg enable;
    reg load;
    reg [7:0] load_addr;

    wire [7:0] pc_out;

    // DUT
    program_counter DUT(
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .load(load),
        .load_addr(load_addr),
        .pc_out(pc_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("program_counter.vcd");
        $dumpvars(0, program_counter_tb);

        clk = 0;
        reset = 0;
        enable = 0;
        load = 0;
        load_addr = 8'h00;

        // TEST 1: Reset
        #10;
        reset = 1;
        #10;
        reset = 0;

        // TEST 2: Increment
        enable = 1;
        #30;

        // TEST 3: Hold
        enable = 0;
        #20;

        // TEST 4: Load new address
        load = 1;
        load_addr = 8'h20;
        #10;
        load = 0;

        // TEST 5: Increment from loaded address
        enable = 1;
        #30;

        // TEST 6: Test overflow
        enable = 0;
        load = 1;
        load_addr = 8'hFF;
        #10;
        load = 0;
        enable = 1;
        #10;

        // Finish
        enable = 0;
        #10;

        $finish;

    end

    initial begin
        $monitor(
            "Time=%0t | reset=%b | enable=%b | load=%b | load_addr=%h | PC=%h",
            $time, reset, enable, load, load_addr, pc_out
        );
    end

endmodule
