
module control_unit(

    input [3:0] opcode,
    input instruction_valid,
    input zero,

    output reg [2:0] alu_sel,

    output reg reg_write,
    output reg alu_src_imm,

    output reg [1:0] wb_sel,

    output reg mem_read,
    output reg mem_write,

    output reg pc_load,
    output reg branch_taken,

    output reg halt,
    output reg illegal

);

    always @(*) begin

        // Default values
        // No operation is performed unless selected

        alu_sel       = 3'b000;
        reg_write     = 1'b0;
        alu_src_imm   = 1'b0;
        wb_sel        = 2'b00;

        mem_read      = 1'b0;
        mem_write     = 1'b0;

        pc_load       = 1'b0;
        branch_taken  = 1'b0;

        halt          = 1'b0;
        illegal       = 1'b0;


        if (instruction_valid) begin

            case(opcode)

                // MOVI: Load immediate value into register
                4'b0000: begin

                    reg_write   = 1'b1;
                    wb_sel      = 2'b01;

                end


                // MOV: Register-to-register transfer
                // Datapath routing will be integrated later
                4'b0001: begin

                    reg_write = 1'b1;
                    wb_sel    = 2'b00;

                end


                // ADD
                4'b0010: begin

                    alu_sel   = 3'b000;
                    reg_write = 1'b1;
                    wb_sel    = 2'b00;

                end


                // SUB
                4'b0011: begin

                    alu_sel   = 3'b001;
                    reg_write = 1'b1;
                    wb_sel    = 2'b00;

                end


                // AND
                4'b0100: begin

                    alu_sel   = 3'b010;
                    reg_write = 1'b1;
                    wb_sel    = 2'b00;

                end


                // OR
                4'b0101: begin

                    alu_sel   = 3'b011;
                    reg_write = 1'b1;
                    wb_sel    = 2'b00;

                end


                // XOR
                4'b0110: begin

                    alu_sel   = 3'b100;
                    reg_write = 1'b1;
                    wb_sel    = 2'b00;

                end


                // LOAD
                4'b0111: begin

                    mem_read  = 1'b1;
                    reg_write = 1'b1;
                    wb_sel    = 2'b10;

                end


                // STORE
                4'b1000: begin

                    mem_write = 1'b1;

                end


                // JMP
                4'b1001: begin

                    pc_load = 1'b1;

                end


                // JZ: Jump if zero flag is HIGH
                4'b1010: begin

                    if (zero) begin

                        pc_load      = 1'b1;
                        branch_taken = 1'b1;

                    end

                end


                // HALT
                4'b1011: begin

                    halt = 1'b1;

                end


                default: begin

                    illegal = 1'b1;

                end

            endcase

        end

        else begin

            illegal = 1'b1;

        end

    end

endmodule
