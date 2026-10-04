
`timescale 1ns/1ps

module register_bank_tb;

    reg clk;
    reg reset;

    reg write_enable;
    reg [1:0] write_addr;
    reg [7:0] write_data;

    reg [1:0] read_addr_a;
    reg [1:0] read_addr_b;

    wire [7:0] read_data_a;
    wire [7:0] read_data_b;

    // Instantiate DUT
    register_bank DUT(
        .clk(clk),
        .reset(reset),

        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),

        .read_addr_a(read_addr_a),
        .read_data_a(read_data_a),

        .read_addr_b(read_addr_b),
        .read_data_b(read_data_b)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 0;

        write_enable = 0;
        write_addr = 0;
        write_data = 0;

        read_addr_a = 0;
        read_addr_b = 0;

        $dumpfile("register_bank.vcd");
        $dumpvars(0, register_bank_tb);

        $monitor(
            "Time=%0t | WE=%b | WADDR=%d | WDATA=%h | RADDR_A=%d | RDATA_A=%h | RADDR_B=%d | RDATA_B=%h",
            $time, write_enable, write_addr, write_data,
            read_addr_a, read_data_a,
            read_addr_b, read_data_b
        );

        // TEST 1: Reset all registers
        #2 reset = 1;
        #10 reset = 0;

        // TEST 2: Write 10 into R0
        @(negedge clk);
        write_enable = 1;
        write_addr = 2'b00;
        write_data = 8'd10;

        @(negedge clk);

        // TEST 3: Write 12 into R1
        write_addr = 2'b01;
        write_data = 8'd12;

        @(negedge clk);

        // TEST 4: Read R0 and R1 simultaneously
        write_enable = 0;

        read_addr_a = 2'b00;
        read_addr_b = 2'b01;

        #2;

        // TEST 5: Read R2 and R3
        read_addr_a = 2'b10;
        read_addr_b = 2'b11;

        #10;

        // TEST 6: Write 22 into R2
        @(negedge clk);
        write_enable = 1;
        write_addr = 2'b10;
        write_data = 8'd22;

        @(negedge clk);
        write_enable = 0;

        // TEST 7: Read R2
        read_addr_a = 2'b10;

        #10;

        $finish;

    end

endmodule
