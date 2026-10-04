
`timescale 1ns/1ps

module control_unit_tb;

    reg [3:0] opcode;
    reg instruction_valid;
    reg zero;

    wire [2:0] alu_sel;

    wire reg_write;
    wire alu_src_imm;

    wire [1:0] wb_sel;

    wire mem_read;
    wire mem_write;

    wire pc_load;
    wire branch_taken;

    wire halt;
    wire illegal;


    // Instantiate Control Unit

    control_unit DUT(

        .opcode(opcode),
        .instruction_valid(instruction_valid),
        .zero(zero),

        .alu_sel(alu_sel),

        .reg_write(reg_write),
        .alu_src_imm(alu_src_imm),

        .wb_sel(wb_sel),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .pc_load(pc_load),
        .branch_taken(branch_taken),

        .halt(halt),
        .illegal(illegal)

    );


    initial begin

        $dumpfile("control_unit.vcd");
        $dumpvars(0, control_unit_tb);

        $monitor(
            "Time=%0t | Opcode=%b | ALU=%b | REG_WE=%b | WB=%b | MEM_R=%b | MEM_W=%b | PC_LOAD=%b | BRANCH=%b | HALT=%b | ILLEGAL=%b",
            $time,
            opcode,
            alu_sel,
            reg_write,
            wb_sel,
            mem_read,
            mem_write,
            pc_load,
            branch_taken,
            halt,
            illegal
        );


        // TEST 1: ADD

        #10;
        instruction_valid = 1;
        zero = 0;
        opcode = 4'b0010;

        #10;

        if(alu_sel == 3'b000 && reg_write == 1 &&
           wb_sel == 2'b00)

            $display("TEST 1 PASSED: ADD");

        else
            $display("TEST 1 FAILED: ADD");


        // TEST 2: MOVI

        #10;
        opcode = 4'b0000;

        #10;

        if(reg_write == 1 && wb_sel == 2'b01)

            $display("TEST 2 PASSED: MOVI");

        else
            $display("TEST 2 FAILED: MOVI");


        // TEST 3: LOAD

        #10;
        opcode = 4'b0111;

        #10;

        if(mem_read == 1 && reg_write == 1 &&
           wb_sel == 2'b10)

            $display("TEST 3 PASSED: LOAD");

        else
            $display("TEST 3 FAILED: LOAD");


        // TEST 4: STORE

        #10;
        opcode = 4'b1000;

        #10;

        if(mem_write == 1 && reg_write == 0)

            $display("TEST 4 PASSED: STORE");

        else
            $display("TEST 4 FAILED: STORE");


        // TEST 5: JMP

        #10;
        opcode = 4'b1001;

        #10;

        if(pc_load == 1)

            $display("TEST 5 PASSED: JMP");

        else
            $display("TEST 5 FAILED: JMP");


        // TEST 6: JZ when zero = 1

        #10;
        opcode = 4'b1010;
        zero = 1;

        #10;

        if(pc_load == 1 && branch_taken == 1)

            $display("TEST 6 PASSED: JZ TAKEN");

        else
            $display("TEST 6 FAILED: JZ TAKEN");


        // TEST 7: JZ when zero = 0

        #10;
        zero = 0;

        #10;

        if(pc_load == 0 && branch_taken == 0)

            $display("TEST 7 PASSED: JZ NOT TAKEN");

        else
            $display("TEST 7 FAILED: JZ NOT TAKEN");


        // TEST 8: HALT

        #10;
        opcode = 4'b1011;

        #10;

        if(halt == 1 && reg_write == 0)

            $display("TEST 8 PASSED: HALT");

        else
            $display("TEST 8 FAILED: HALT");


        // TEST 9: Invalid instruction

        #10;
        opcode = 4'b1100;
        instruction_valid = 0;

        #10;

        if(illegal == 1 && reg_write == 0)

            $display("TEST 9 PASSED: INVALID");

        else
            $display("TEST 9 FAILED: INVALID");


        #10;

        $finish;

    end

endmodule
