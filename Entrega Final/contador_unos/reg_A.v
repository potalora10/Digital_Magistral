module reg_A_unos (
    input  wire        clk,
    input  wire        sh,     
    input  wire        ld,     
    input  wire [15:0] in_A,
    output reg  [15:0] A,
    output wire         LSB_A
);

    always @(negedge clk) begin
        if (ld)
            A <= in_A;
        else if (sh)
            A <= A >> 1;
    end

    assign LSB_A = A[0];

endmodule
