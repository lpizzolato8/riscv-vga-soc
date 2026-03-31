timescale 1ns/1ps

alu_tb # (



)

alutest (

    .i_A(i_A),
    .i_B(i_B),
    .i_OPSEL(i_OPSEL),
    
    .o_RESULT(o_RESULT),
    .zero(zero)


);