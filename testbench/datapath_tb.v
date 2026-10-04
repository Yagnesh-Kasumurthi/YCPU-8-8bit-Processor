
`timescale 1ns/1ps

module datapath_tb;

    reg clk;
    reg reset;

    reg [1:0] read_addr_a;
    reg [1:0] read_addr_b;
    reg [1:0] write_addr;

    reg [2:0] alu_sel;

    reg write_enable;
    reg [7:0] external_data;
    reg writeback_sel;

    wire [7:0] read_data_a;
    wire [7:0] read_data_b;
    wire [7:0] alu_result;

    wire carry;
    wire zero;


    // Instantiate datapath

    datapath DUT(

        .clk(clk),
        .reset(reset),

        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .write_addr(write_addr),

        .alu_sel(alu_sel),

        .write_enable(write_enable),

        .external_data(external_data),
        .writeback_sel(writeback_sel),

        .read_data_a(read_data_a),
        .read_data_b(read_data_b),

        .alu_result(alu_result),

        .carry(carry),
        .zero(zero)

    );


    // Clock generation

    always #5 clk = ~clk;


    initial begin

        $dumpfile("datapath.vcd");
        $dumpvars(0, datapath_tb);

        $monitor(
            "Time=%0t | RADDR_A=%d | RADDR_B=%d | A=%d | B=%d | ALU=%d | RESULT=%d | WE=%b",
            $time,
            read_addr_a,
            read_addr_b,
            read_data_a,
            read_data_b,
            alu_sel,
            alu_result,
            write_enable
        );


        // Initial values

        clk = 0;
        reset = 1;

        read_addr_a = 0;
        read_addr_b = 0;
        write_addr = 0;

        alu_sel = 0;

        write_enable = 0;
        external_data = 0;
        writeback_sel = 0;

        #12;
        reset = 0;


        // STEP 1: Load 10 into R0

        @(negedge clk);

        write_enable = 1;
        write_addr = 0;
        external_data = 10;
        writeback_sel = 0;

        @(posedge clk);
        #1;

        $display("R0 loaded with 10");


        // STEP 2: Load 12 into R1

        @(negedge clk);

        write_addr = 1;
        external_data = 12;

        @(posedge clk);
        #1;

        $display("R1 loaded with 12");


        // STEP 3: Read R0 and R1

        @(negedge clk);

        write_enable = 0;

        read_addr_a = 0;
        read_addr_b = 1;

        alu_sel = 3'b000;

        #1;

        $display("A = %d, B = %d", read_data_a, read_data_b);
        $display("ALU RESULT = %d", alu_result);


        // STEP 4: Write ALU result into R0

        @(negedge clk);

        write_enable = 1;
        write_addr = 0;
        writeback_sel = 1;

        @(posedge clk);
        #1;

        $display("ALU result written into R0");


        // STEP 5: Read updated R0

        @(negedge clk);

        write_enable = 0;

        read_addr_a = 0;
        read_addr_b = 1;

        #1;

        $display("Updated R0 = %d", read_data_a);
        $display("R1 = %d", read_data_b);


        #10;

        $finish;

    end

endmodule
