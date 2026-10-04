
module ycpu_top_tb;

    reg clk;
    reg reset;

    wire [7:0] pc_out;
    wire halt;
    wire illegal;


    // ==========================================
    // DUT: DEVICE UNDER TEST
    // ==========================================

    ycpu_top DUT(

        .clk(clk),
        .reset(reset),

        .pc_out(pc_out),
        .halt(halt),
        .illegal(illegal)

    );


    // ==========================================
    // CLOCK GENERATION
    // ==========================================

    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end


    // ==========================================
    // TEST EXECUTION
    // ==========================================

    initial begin

        $dumpfile("ycpu.vcd");
        $dumpvars(0, ycpu_top_tb);

        reset = 1;

        #20;

        reset = 0;

        $display("--------------------------------");
        $display("       YCPU-8 JZ TEST");
        $display("--------------------------------");


        // Wait until processor executes HALT

        wait(halt == 1'b1);

        #1;


        // ======================================
        // DISPLAY PROCESSOR RESULTS
        // ======================================

        $display("");
        $display("PROCESSOR HALTED");

        $display("PC = %d", pc_out);

        $display("R0 = %d",
            DUT.DP.RB.registers[0]);

        $display("R1 = %d",
            DUT.DP.RB.registers[1]);

        $display("R2 = %d",
            DUT.DP.RB.registers[2]);

        $display("R3 = %d",
            DUT.DP.RB.registers[3]);

        $display("HALT = %b", halt);

        $display("ILLEGAL = %b", illegal);


        // ======================================
        // AUTOMATIC RESULT VERIFICATION
        // ======================================

        if (

            DUT.DP.RB.registers[0] == 8'd0 &&

            DUT.DP.RB.registers[1] == 8'd12 &&

            DUT.DP.RB.registers[2] == 8'd0 &&

            DUT.DP.RB.registers[3] == 8'd0 &&

            pc_out == 8'd5 &&

            halt == 1'b1 &&

            illegal == 1'b0

        ) begin

            $display("");
            $display("================================");
            $display(" YCPU-8 JZ EXECUTED SUCCESSFULLY");
            $display(" ALL TESTS PASSED");
            $display("================================");

        end

        else begin

            $display("");
            $display("================================");
            $display(" TEST FAILED");
            $display(" CHECK YOUR DESIGN");
            $display("================================");

        end


        $finish;

    end


    // ==========================================
    // TIMEOUT PROTECTION
    // ==========================================

    initial begin

        #1000;

        $display("");
        $display("ERROR: PROCESSOR TIMEOUT");

        $finish;

    end

endmodule
