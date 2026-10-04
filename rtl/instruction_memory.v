
module instruction_memory(

    input [7:0] address,
    output [15:0] instruction

);

    // ==========================================
    // INSTRUCTION MEMORY
    // ==========================================

    // 256 locations
    // Each location stores a 16-bit instruction

    reg [15:0] memory [0:255];

    integer i;


    // ==========================================
    // PROGRAM INITIALIZATION
    // ==========================================

    initial begin

        // Initialize all memory locations
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 16'h0000;


        // ======================================
// YCPU-8 JZ TEST PROGRAM
// ======================================

// Instruction 0:
// MOVI R0, 0
memory[0] = 16'h0000;


// Instruction 1:
// JZ 4
memory[1] = 16'hA004;


// Instruction 2:
// MOVI R1, 99
// Should be skipped
memory[2] = 16'h0463;


// Instruction 3:
// MOVI R1, 88
// Should be skipped
memory[3] = 16'h0458;


// Instruction 4:
// MOVI R1, 12
memory[4] = 16'h040C;


// Instruction 5:
// HALT
memory[5] = 16'hB000;

    end


    // ==========================================
    // INSTRUCTION FETCH
    // ==========================================

    // PC provides address
    // Memory returns corresponding instruction

    assign instruction = memory[address];


endmodule
