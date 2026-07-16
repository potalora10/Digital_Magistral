module reg_X_hold (
    input  wire        clk,
    input  wire        ld,    
    input  wire [15:0] in_X,
    output reg  [15:0] X_hold
);

    always @(negedge clk) begin
        if (ld)
            X_hold <= in_X;
    end

endmodule
