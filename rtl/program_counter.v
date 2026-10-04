
module program_counter(
    input clk,
    input reset,
    input enable,
    input load,
    input [7:0] load_addr,

    output reg [7:0] pc_out
);

    always @(posedge clk) begin

        if (reset)
            pc_out <= 8'h00;

        else if (load)
            pc_out <= load_addr;

        else if (enable)
            pc_out <= pc_out + 1'b1;

    end

endmodule
