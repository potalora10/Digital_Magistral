`timescale 1ns/1ps
module reg_Q_raiz (
    input  wire        clk,
    input  wire        ld,    
    input  wire        inc,   
    output reg  [15:0] Q
);

    always @(negedge clk) begin
        if (ld)
            Q <= 16'h0000;
        else if (inc)
            Q <= Q + 16'h0001;
    end

endmodule
