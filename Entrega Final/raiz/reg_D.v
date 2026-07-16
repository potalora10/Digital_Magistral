`timescale 1ns/1ps
module reg_D (
    input  wire        clk,
    input  wire        add,    
    input  wire        ld,     
    output reg  [15:0] D
);

    always @(negedge clk) begin
        if (ld)
            D <= 16'h0001;
        else if (add)
            D <= D + 16'h0002;
    end

endmodule
