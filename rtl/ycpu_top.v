
module ycpu_top(

    input clk,
    input reset,

    output [7:0] pc_out,
    output halt,
    output illegal

);

    // ==========================================
    // 1. INTERNAL WIRES
    // ==========================================

    wire [15:0] instruction;

    wire [3:0] opcode;
    wire [1:0] rd;
    wire [1:0] rs;
    wire [7:0] immediate;

    wire instruction_valid;
    wire decoder_halt;

    wire [2:0] alu_sel;

    wire reg_write;
    wire alu_src_imm;

    wire [1:0] wb_sel;

    wire mem_read;
    wire mem_write;

    wire pc_load;
    wire branch_taken;

    wire [7:0] read_data_a;
    wire [7:0] read_data_b;

    wire [7:0] alu_result;
    wire carry;
    wire zero;

    wire [7:0] memory_data;
    wire [7:0] external_data;
    wire [7:0] memory_write_data;

    wire pc_enable;


    // ==========================================
    // 2. PROGRAM COUNTER
    // ==========================================

    assign pc_enable = instruction_valid &&
                       !halt &&
                       !illegal;

    program_counter PC(

        .clk(clk),
        .reset(reset),

        .enable(pc_enable),
        .load(pc_load),
        .load_addr(immediate),

        .pc_out(pc_out)

    );


    // ==========================================
    // 3. INSTRUCTION MEMORY
    // ==========================================

    instruction_memory IMEM(

        .address(pc_out),
        .instruction(instruction)

    );


    // ==========================================
    // 4. INSTRUCTION DECODER
    // ==========================================

    instruction_decoder DEC(

        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .immediate(immediate),

        .valid(instruction_valid),
        .halt(decoder_halt)

    );


    // ==========================================
    // 5. CONTROL UNIT
    // ==========================================

    control_unit CU(

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


    // ==========================================
    // 6. DATAPATH
    // ==========================================

    // Select data for register writeback

    assign external_data =
        (wb_sel == 2'b01) ? immediate :
        (wb_sel == 2'b10) ? memory_data :
                             8'h00;

    // 00 = ALU result
    // 01 = Immediate
    // 10 = Memory data

    datapath DP(

        .clk(clk),
        .reset(reset),

        .read_addr_a(rd),
        .read_addr_b(rs),

        .write_addr(rd),

        .alu_sel(alu_sel),

        .write_enable(reg_write),

        .external_data(external_data),

        .writeback_sel(wb_sel == 2'b00),

        .read_data_a(read_data_a),
        .read_data_b(read_data_b),

        .alu_result(alu_result),

        .carry(carry),
        .zero(zero)

    );


    // ==========================================
    // 7. DATA MEMORY
    // ==========================================

    // STORE uses register RD as data.
    // LOAD and STORE use immediate as address.

    assign memory_write_data = read_data_a;

    data_memory DMEM(

        .clk(clk),
        .reset(reset),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .address(immediate),

        .write_data(memory_write_data),
        .read_data(memory_data)

    );


endmodule
