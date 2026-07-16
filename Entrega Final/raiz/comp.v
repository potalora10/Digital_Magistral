`timescale 1ns/1ps
module comp_raiz (
    input  wire [15:0] X,
    input  wire [15:0] D,
    output wire         z
);

    assign z = (X >= D);

endmodule
