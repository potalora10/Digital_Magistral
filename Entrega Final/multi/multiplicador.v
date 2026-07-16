module multiplicador (
    input  wire        clk,
    input  wire        rst,     
    input  wire        start,
    input  wire [15:0] A,
    input  wire [15:0] B,
    output wire [31:0] P,
    output wire         done
);

    // Senales de control
    wire w_LD, w_SH, w_ADD, w_RST;

    // Senales de estado 
    wire w_x, w_z, w_Blsb;

    // Buses internos del datapath 
    wire [31:0] w_Areg;
    wire [15:0] w_Breg;

    // DATAPATH

    reg_A u_reg_A (
        .clk   (clk),
        .load  (w_LD),
        .shift (w_SH),
        .in_A  (A),
        .out_A (w_Areg)
    );

    reg_B u_reg_B (
        .clk   (clk),
        .load  (w_LD),
        .shift (w_SH),
        .in_B  (B),
        .out_B (w_Breg),
        .B_LSB (w_Blsb)
    );

    comparador u_comp (
        .B (w_Breg),
        .z (w_z),
        .x (w_x)
    );

    acumulador u_acc (
        .clk  (clk),
        .add  (w_ADD),
        .rst  (w_RST),
        .in_A (w_Areg),
        .P    (P)
    );

    // CONTROL

    control_mult u_ctrl (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .x     (w_x),
        .z     (w_z),
        .done  (done),
        .LD    (w_LD),
        .SH    (w_SH),
        .ADD   (w_ADD),
        .RST   (w_RST)
    );

endmodule
