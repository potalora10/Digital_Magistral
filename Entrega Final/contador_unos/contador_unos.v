module contador_unos (
    input  wire        clk,
    input  wire        rst,    // reset global del sistema
    input  wire        start,
    input  wire [15:0] A,
    output wire [4:0]  C,
    output wire         done
);

    //  Senales de control 
    wire w_SH, w_LD, w_INC;

    // ---- Senales de estado (Datapath -> Control) ----
    wire w_lsb_a, w_z;

    // ---- Buses internos del datapath ----
    wire [15:0] w_Areg;
    wire [4:0]  w_Creg;

    // DATAPATH 

    reg_A_unos u_reg_A (
        .clk   (clk),
        .sh    (w_SH),
        .ld    (w_LD),
        .in_A  (A),
        .A     (w_Areg),
        .LSB_A (w_lsb_a)
    );

    comp_unos u_comp (
        .A (w_Areg),
        .z (w_z)
    );

    reg_C u_reg_C (
        .clk (clk),
        .ld  (w_LD),
        .inc (w_INC),
        .C   (w_Creg)
    );

    // CONTROL 

    control_unos u_ctrl (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .lsb_a (w_lsb_a),
        .z     (w_z),
        .done  (done),
        .SH    (w_SH),
        .LD    (w_LD),
        .INC   (w_INC)
    );

    assign C = w_Creg;

endmodule
