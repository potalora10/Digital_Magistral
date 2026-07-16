module comparador (
    input  wire [15:0] B,
    output wire         z,
    output wire         x
);

    assign z = (B == 16'b0);
    assign x = B[0];

endmodule
