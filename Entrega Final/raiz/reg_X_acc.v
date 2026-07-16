`timescale 1ns/1ps
module reg_X_acc (
    input  wire        clk,
    input  wire        ld,    
    input  wire        add,   
    input  wire [15:0] in_X,  
    input  wire [15:0] D,
    output reg  [15:0] X
);

    always @(negedge clk) begin
        if (ld)
            X <= in_X;
        else if (add)
            X <= X - D;
    end

endmodule
