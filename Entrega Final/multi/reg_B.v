module reg_B (
    input  wire        clk,
    input  wire        load,   
    input  wire        shift, 
    input  wire [15:0] in_B,
    output reg  [15:0] out_B,
    output wire         B_LSB
);

    always @(negedge clk) begin
        if (load)
            out_B <= in_B;
        else if (shift)
            out_B <= out_B >> 1;
    end

    assign B_LSB = out_B[0];

endmodule
