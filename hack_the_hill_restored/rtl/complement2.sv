module complement2(
    input logic [19:0] i, 
    output logic [19:0] o
);

    assign o = -i; 
endmodule