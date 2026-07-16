module reg_i (
    input  wire       clk,
    input  wire       reset_i,  
    input  wire       dec,      
    output reg  [4:0] i_count
);

    localparam [4:0] N = 5'd16;

    always @(negedge clk) begin
        if (reset_i)
            i_count <= N;
        else if (dec)
            i_count <= i_count - 5'd1;
    end

endmodule
