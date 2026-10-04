
module alu(
    input [7:0] a,
    input [7:0] b,

    input [2:0] alu_sel,

    output reg [7:0] result,
    output reg carry,
    output zero
);

    reg [8:0] temp;

    always @(*) begin

        // Default values
        result = 8'b00000000;
        carry = 1'b0;
        temp = 9'b000000000;

        case (alu_sel)

            // ADD
            3'b000: begin
                temp = {1'b0, a} + {1'b0, b};
                result = temp[7:0];
                carry = temp[8];
            end

            // SUB
            3'b001: begin
                temp = {1'b0, a} - {1'b0, b};
                result = temp[7:0];
                carry = (a < b);
            end

            // AND
            3'b010: begin
                result = a & b;
            end

            // OR
            3'b011: begin
                result = a | b;
            end

            // XOR
            3'b100: begin
                result = a ^ b;
            end

            // NOT A
            3'b101: begin
                result = ~a;
            end

            // Reserved operations
            default: begin
                result = 8'b00000000;
                carry = 1'b0;
            end

        endcase

    end

    // Zero flag
    assign zero = (result == 8'b00000000);

endmodule
