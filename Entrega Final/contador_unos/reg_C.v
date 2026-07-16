module reg_C (
    input  wire       clk,
    input  wire       ld,   
    input  wire       inc,  
    output reg  [4:0] C
);

    always @(negedge clk) begin
        if (ld)
            C <= 5'b0;
        else if (inc)
            C <= C + 5'd1;
    end

endmodule
