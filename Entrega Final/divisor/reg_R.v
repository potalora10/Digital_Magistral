module reg_R (
    input  wire        clk,
    input  wire        reset_r,  
    input  wire        ldr,      
    input  wire        sh,       
    input  wire [15:0] in_R,     
    input  wire        msb_Q,    
    output reg  [15:0] R
);

    always @(negedge clk) begin
        if (reset_r)
            R <= 16'b0;
        else if (ldr)
            R <= in_R;
        else if (sh)
            R <= {R[14:0], msb_Q};
    end

endmodule
