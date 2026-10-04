
`timescale 1ns/1ps

module register_tb;

    reg clk;
    reg reset;
    reg enable;

    reg [7:0] data_in;

    wire [7:0] data_out;

    // Instantiate the register
    register DUT(
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Generate clock
    always #5 clk = ~clk;

    initial begin

        // Initialise signals
        clk = 0;
        reset = 0;
        enable = 0;
        data_in = 8'b00000000;

        $dumpfile("register.vcd");
        $dumpvars(0, register_tb);

        $monitor("Time=%0t | clk=%b | reset=%b | enable=%b | data_in=%b | data_out=%b",
                 $time, clk, reset, enable, data_in, data_out);

        // TEST 1: Reset
        #2 reset = 1;
        #9 reset = 0;

        // TEST 2: Load first data
        #1 enable = 1;
           data_in = 8'b10101010;

        #10;

        // TEST 3: Load second data
        data_in = 8'b11110000;

        #10;

        // TEST 4: Disable enable and change input
        enable = 0;
        data_in = 8'b01010101;

        #10;

        // TEST 5: Enable again
        enable = 1;
        data_in = 8'b11001100;

        #10;

        // TEST 6: Reset while enable is active
        reset = 1;

        #10 reset = 0;

        #10;

        $finish;

    end

endmodule
