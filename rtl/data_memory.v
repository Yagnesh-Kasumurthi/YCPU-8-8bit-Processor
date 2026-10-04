module data_memory(

    input clk,
    input reset,

    input mem_read,
    input mem_write,

    input [7:0] address,
    input [7:0] write_data,

    output [7:0] read_data

);

    // 256 locations, each storing 8 bits
    reg [7:0] memory [0:255];

    integer i;

    // Initialize memory
    always @(posedge clk) begin

        if (reset) begin

            for (i = 0; i < 256; i = i + 1)
                memory[i] <= 8'h00;

        end

        else if (mem_write) begin

            memory[address] <= write_data;

        end

    end

    // Asynchronous read
    assign read_data = mem_read ? memory[address] : 8'h00;

endmodule