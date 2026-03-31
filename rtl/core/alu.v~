timescale 1ns/1ps

module alu (

    input  [31:0]  i_A, i_B,
    input  [3:0]   i_OPSEL,
    
    output reg [31:0]  o_RESULT,
    output zero

);

    
    always @(*) begin

        case (i_OPSEL)
        
            4'b0000: o_RESULT = i_A + i_B;  //addition

            4'b0001: o_RESULT = i_A - i_B;  //subtraction
        
            4'b0010: o_RESULT = i_A & i_B;  //AND

            4'b0011: o_RESULT = i_A ^ i_B;  //XOR
        
            4'b0100: o_RESULT = i_A | i_B;  //OR

            // RISCV32I architecture only shifts using the 5 least significant bits for the shift amount 
            // if trying to shift by any amount greater than 5 and system will return an error

            4'b0101: o_RESULT = i_A << i_B[4:0];  //shift left logical

            4'b0110: o_RESULT = i_A >> i_B[4:0];  //shift right logical
            
            4'b0111: o_RESULT = $signed(i_A) >>> i_B[4:0]; // shift right arithmatic

            4'b1000: o_RESULT = $signed(i_A) < $signed(i_B) ? 32'b1 : 32'b0;  // signed 

            4'b1001: o_RESULT = i_A < i_B ? 32'b1 : 32'b0;  // unsigned 

            default: o_RESULT = 32'b0;

        endcase

    end

    // if result ever returns 0 then set the zero flag to high
    // this is a separate output wire bc the branch logic needs to read it directly

    assign zero = (o_RESULT == 32'b0);



endmodule