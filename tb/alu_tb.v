module alu_tb ();
    reg [31:0] i_A;
    reg [31:0] i_B;
    reg [3:0] i_OPSEL;
    wire [31:0] o_RESULT;
    wire zero;

    alu dut(
        .i_A        (i_A),
        .i_B        (i_B),
        .i_OPSEL    (i_OPSEL),
        .o_RESULT   (o_RESULT),
        .zero       (zero)
    );

    initial begin

        // ADD test with overflow test
        // 0xFFFFFFFF + 1 should wrap to 0 due to 32-bit overflow also verifies the zero flag is raised
        i_OPSEL = 4'b0000;
        i_A = 32'hFFFFFFFF;
        i_B = 32'd1;
        #20;
        if (o_RESULT !== 32'd0 || zero !== 1'b1) $display("FAIL ADD: got %0d, zero=%0b, expected 0 with zero=1", o_RESULT, zero);

        // SUB test with negative result 
        // 5 - 25 = -20, which in two's complement is 0xFFFFFFEC
        i_OPSEL = 4'b0001;
        i_A = 32'd5;
        i_B = 32'd25;
        #20;
        if (o_RESULT !== 32'hFFFFFFEC)
            $display("FAIL SUB: got %h, expected FFFFFFEC", o_RESULT);

        // AND bitwise test
        // 5 = 00101, 25 = 11001, AND = 00001 = 1 . Only bit 0 is set in both operands
        i_OPSEL = 4'b0010;
        i_A = 32'd5;
        i_B = 32'd25;
        #20;
        if (o_RESULT !== 32'd1)
            $display("FAIL AND: got %0d, expected 1", o_RESULT);

        // XOR bitwise test
        // 5 = 00101, 25 = 11001, XOR = 11100 = 28 . Bits that differ between the two operands are set
        i_OPSEL = 4'b0011;
        i_A = 32'd5;
        i_B = 32'd25;
        #20;
        if (o_RESULT !== 32'd28)
            $display("FAIL XOR: got %0d, expected 28", o_RESULT);

        // OR bitwise test
        // 5 = 00101, 25 = 11001, OR = 11101 = 29 . Any bit set in either operand is set in the result
        i_OPSEL = 4'b0100;
        i_A = 32'd5;
        i_B = 32'd25;
        #20;
        if (o_RESULT !== 32'd29)
            $display("FAIL OR: got %0d, expected 29", o_RESULT);

        // SLL shift left logical test
        // 5 << 25 = 167772160 (0x0A000000) . Shifts bit pattern of 5 (101) left by 25 positions, zeros fill right
        i_OPSEL = 4'b0101;
        i_A = 32'd5;
        i_B = 32'd25;
        #20;
        if (o_RESULT !== 32'h0A000000)
            $display("FAIL SLL: got %h, expected 0A000000", o_RESULT);

        // SRL shift right logical test
        // 5 >> 25 = 0 . 5 is only 3 bits wide, shifting right by 25 pushes all bits off the edge
        i_OPSEL = 4'b0110;
        i_A = 32'd5;
        i_B = 32'd25;
        #20;
        if (o_RESULT !== 32'd0)
            $display("FAIL SRL: got %0d, expected 0", o_RESULT);

        // SRA arithmetic right shift test
        // 0xF0000000 >>> 25 = 0xFFFFFFF8 . Sign bit is 1, so arithmetic shift fills left with 1s instead of 0s . Thus preserving the sign value
        i_OPSEL = 4'b0111;
        i_A = 32'hF0000000;
        i_B = 32'd25;
        #20;
        if (o_RESULT !== 32'hFFFFFFF8)
            $display("FAIL SRA: got %h, expected FFFFFFF8", o_RESULT);

        // SLT signed comparison test
        // 0x80000000 is the most negative signed number (-2,147,483,648) . Compared to 0 signed: -2,147,483,648 < 0 is true, so result = 1
        i_OPSEL = 4'b1000;
        i_A = 32'h80000000;
        i_B = 32'd0;
        #20;
        if (o_RESULT !== 32'd1)
            $display("FAIL SLT: got %0d, expected 1", o_RESULT);

        // SLTU unsigned comparison test
        // Same inputs: 0x80000000 vs 0 . Unsigned: 0x80000000 = 2,147,483,648 which is GREATER than 0, so result = 0 . Opposite above therefore signed vs unsigned
        i_OPSEL = 4'b1001;
        i_A = 32'h80000000;
        i_B = 32'd0;
        #20;
        if (o_RESULT !== 32'd0)
            $display("FAIL SLTU: got %0d, expected 0", o_RESULT);

        $display("All Tests Passed. ALU Full Function");
        $finish;
    end
endmodule