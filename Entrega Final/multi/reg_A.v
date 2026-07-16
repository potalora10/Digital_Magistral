module reg_A (
    input  wire        clk,
    input  wire        load,   
    input  wire        shift,  
    input  wire [15:0] in_A,
    output reg  [31:0] out_A
);

    always @(negedge clk) begin
        if (load)
            out_A <= {16'b0, in_A};
        else if (shift)
            out_A <= out_A << 1;
    end

endmodule
