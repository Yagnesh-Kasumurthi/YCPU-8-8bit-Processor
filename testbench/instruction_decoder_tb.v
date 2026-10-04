
`timescale 1ns/1ps

module instruction_decoder_tb;

    reg [15:0] instruction;

    wire [3:0] opcode;
    wire [1:0] rd;
    wire [1:0] rs;
    wire [7:0] immediate;

    wire valid;
    wire halt;


    // Instantiate Instruction Decoder

    instruction_decoder DUT(

        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .immediate(immediate),

        .valid(valid),
        .halt(halt)

    );


    initial begin

        $dumpfile("instruction_decoder.vcd");
        $dumpvars(0, instruction_decoder_tb);

        $monitor(
            "Time=%0t | Instruction=%b | Opcode=%b | RD=%d | RS=%d | Immediate=%h | Valid=%b | Halt=%b",
            $time,
            instruction,
            opcode,
            rd,
            rs,
            immediate,
            valid,
            halt
        );


        // TEST 1: ADD R0, R1

        #10;
        instruction = 16'b0010_00_01_00001100;

        #10;

        if(opcode == 4'b0010 &&
           rd == 2'b00 &&
           rs == 2'b01 &&
           valid == 1 &&
           halt == 0)

            $display("TEST 1 PASSED: ADD instruction");

        else
            $display("TEST 1 FAILED");


        // TEST 2: MOVI R2, 42

        #10;
        instruction = 16'b0000_10_00_00101010;

        #10;

        if(opcode == 4'b0000 &&
           rd == 2'b10 &&
           immediate == 8'd42 &&
           valid == 1)

            $display("TEST 2 PASSED: MOVI instruction");

        else
            $display("TEST 2 FAILED");


        // TEST 3: HALT

        #10;
        instruction = 16'b1011_00_00_00000000;

        #10;

        if(halt == 1 && valid == 1)

            $display("TEST 3 PASSED: HALT instruction");

        else
            $display("TEST 3 FAILED");


        // TEST 4: Invalid instruction

        #10;
        instruction = 16'b1100_00_00_00000000;

        #10;

        if(valid == 0 && halt == 0)

            $display("TEST 4 PASSED: Invalid instruction");

        else
            $display("TEST 4 FAILED");


        #10;

        $finish;

    end

endmodule
