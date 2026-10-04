
`timescale 1ns/1ps

module alu_tb;

    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] alu_sel;

    wire [7:0] result;
    wire carry;
    wire zero;

    // Instantiate ALU
    alu DUT(
        .a(a),
        .b(b),
        .alu_sel(alu_sel),
        .result(result),
        .carry(carry),
        .zero(zero)
    );

    initial begin

        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        $monitor(
            "Time=%0t | A=%d | B=%d | SEL=%b | RESULT=%d | CARRY=%b | ZERO=%b",
            $time, a, b, alu_sel, result, carry, zero
        );

        // Test 1: Addition
        a = 10;
        b = 12;
        alu_sel = 3'b000;
        #10;

        // Test 2: Subtraction
        a = 12;
        b = 10;
        alu_sel = 3'b001;
        #10;

        // Test 3: AND
        a = 8'b11110000;
        b = 8'b00001111;
        alu_sel = 3'b010;
        #10;

        // Test 4: OR
        a = 8'b11110000;
        b = 8'b00001111;
        alu_sel = 3'b011;
        #10;

        // Test 5: XOR
        a = 8'b11110000;
        b = 8'b00001111;
        alu_sel = 3'b100;
        #10;

        // Test 6: NOT
        a = 8'b00001111;
        b = 0;
        alu_sel = 3'b101;
        #10;

        // Test 7: Zero flag
        a = 10;
        b = 10;
        alu_sel = 3'b001;
        #10;

        // Test 8: Carry
        a = 255;
        b = 1;
        alu_sel = 3'b000;
        #10;

        // Test 9: Borrow
        a = 5;
        b = 10;
        alu_sel = 3'b001;
        #10;

        $finish;

    end

endmodule
