
module datapath(

    input clk,
    input reset,

    // Register selection
    input [1:0] read_addr_a,
    input [1:0] read_addr_b,
    input [1:0] write_addr,

    // ALU control
    input [2:0] alu_sel,

    // Register write control
    input write_enable,

    // External data input
    input [7:0] external_data,

    // 0 = External data
    // 1 = ALU result
    input writeback_sel,

    // Outputs
    output [7:0] read_data_a,
    output [7:0] read_data_b,
    output [7:0] alu_result,
    output carry,
    output zero
);

    wire [7:0] write_data;

    // =================================
    // WRITE BACK MULTIPLEXER
    // =================================

    assign write_data = writeback_sel ?
                        alu_result : external_data;


    // =================================
    // REGISTER BANK
    // =================================

    register_bank RB(

        .clk(clk),
        .reset(reset),

        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),

        .read_data_a(read_data_a),
        .read_data_b(read_data_b),

        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable)

    );


    // =================================
    // ALU
    // =================================

    alu ALU_UNIT(

        .a(read_data_a),
        .b(read_data_b),

        .alu_sel(alu_sel),

        .result(alu_result),
        .carry(carry),
        .zero(zero)

    );

endmodule
