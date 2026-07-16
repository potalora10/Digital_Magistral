module acumulador (
    input  wire        clk,
    input  wire        add,    
    input  wire        rst,    
    input  wire [31:0] in_A,
    output reg  [31:0] P
);

    always @(negedge clk) begin
        if (rst)
            P <= 32'b0;
        else if (add)
            P <= P + in_A;
    end

endmodule
