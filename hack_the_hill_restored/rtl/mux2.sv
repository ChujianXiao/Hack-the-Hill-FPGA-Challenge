module mux2 #(parameter N=3) (
    input i_select,
    input[N-1:0] i_input0,
    input[N-1:0] i_input1,
    output[N-1:0] o_output
);

always_comb
    case(i_select)
        0: o_output = i_input0;
        1: o_output = i_input1;
    endcase

endmodule