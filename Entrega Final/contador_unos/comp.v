module comp_unos (
    input  wire [15:0] A,
    output wire         z
);

    assign z = (A == 16'b0);

endmodule
