
module register_bank(
    input clk,
    input reset,

    // Write port
    input write_enable,
    input [1:0] write_addr,
    input [7:0] write_data,

    // Read port A
    input [1:0] read_addr_a,
    output [7:0] read_data_a,

    // Read port B
    input [1:0] read_addr_b,
    output [7:0] read_data_b
);

    // Four 8-bit registers
    reg [7:0] registers [0:3];

    integer i;

    // Sequential logic: Reset and Write
    always @(posedge clk) begin

        if (reset) begin

            for (i = 0; i < 4; i = i + 1)
                registers[i] <= 8'b00000000;

        end

        else if (write_enable) begin

            registers[write_addr] <= write_data;

        end

    end

    // Combinational logic: Read
    assign read_data_a = registers[read_addr_a];

    assign read_data_b = registers[read_addr_b];

endmodule
