module reg_Q (
    input  wire        clk,
    input  wire        ldq,    
    input  wire        sh,     
    input  wire        q0,     
    input  wire [15:0] in_Q,   
    output reg  [15:0] Q
);

    always @(negedge clk) begin
        if (ldq)
            Q <= in_Q;
        else if (sh)
            Q <= {Q[14:0], q0};
        else if (q0)
            Q[0] <= 1'b1;
    end

endmodule
