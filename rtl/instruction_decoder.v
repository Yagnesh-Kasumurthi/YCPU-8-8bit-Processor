
module instruction_decoder(

    input [15:0] instruction,

    output [3:0] opcode,
    output [1:0] rd,
    output [1:0] rs,
    output [7:0] immediate,

    output valid,
    output halt

);

    // Extract instruction fields

    assign opcode    = instruction[15:12];
    assign rd        = instruction[11:10];
    assign rs        = instruction[9:8];
    assign immediate = instruction[7:0];


    // Identify valid instructions

    reg valid_reg;

    always @(*) begin

        case(opcode)

            4'b0000: valid_reg = 1'b1; // MOVI
            4'b0001: valid_reg = 1'b1; // MOV
            4'b0010: valid_reg = 1'b1; // ADD
            4'b0011: valid_reg = 1'b1; // SUB
            4'b0100: valid_reg = 1'b1; // AND
            4'b0101: valid_reg = 1'b1; // OR
            4'b0110: valid_reg = 1'b1; // XOR
            4'b0111: valid_reg = 1'b1; // LOAD
            4'b1000: valid_reg = 1'b1; // STORE
            4'b1001: valid_reg = 1'b1; // JMP
            4'b1010: valid_reg = 1'b1; // JZ
            4'b1011: valid_reg = 1'b1; // HALT

            default: valid_reg = 1'b0;

        endcase

    end

    assign valid = valid_reg;

    assign halt = (opcode == 4'b1011);

endmodule
