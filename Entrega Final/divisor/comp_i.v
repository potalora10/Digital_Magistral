module comp_i (
    input  wire [4:0] i_count,
    output wire        z
);

    assign z = (i_count == 5'b0);

endmodule
