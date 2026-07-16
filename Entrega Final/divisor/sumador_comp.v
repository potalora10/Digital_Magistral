module sumador_comp (
    input  wire [15:0] R,
    input  wire [15:0] V,
    output wire [15:0] diff,
    output wire         MSB_R
);

    wire [16:0] resta;

    assign resta = {1'b0, R} - {1'b0, V};
    assign diff  = resta[15:0];
    assign MSB_R = ~resta[16];   
endmodule
