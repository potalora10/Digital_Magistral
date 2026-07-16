module divisor (
    input  wire        clk,
    input  wire        rst,    // reset global del sistema
    input  wire        start,
    input  wire [15:0] Q,      // dividendo
    input  wire [15:0] V,      // divisor
    output wire [15:0] P,      // cociente
    output wire [15:0] R,      // residuo
    output wire         done
);

    wire w_LDR, w_Q0, w_SH, w_LDQ, w_DECi;

    wire w_msb_r, w_z;

    wire [15:0] w_Rreg, w_Qreg, w_diff;
    wire [4:0]  w_icount;

    //  DATAPATH 

    reg_R u_reg_R (
        .clk     (clk),
        .reset_r (w_LDQ),
        .ldr     (w_LDR),
        .sh      (w_SH),
        .in_R    (w_diff),
        .msb_Q   (w_Qreg[15]),
        .R       (w_Rreg)
    );

    reg_Q u_reg_Q (
        .clk  (clk),
        .ldq  (w_LDQ),
        .sh   (w_SH),
        .q0   (w_Q0),
        .in_Q (Q),
        .Q    (w_Qreg)
    );

    reg_i u_reg_i (
        .clk     (clk),
        .reset_i (w_LDQ),
        .dec     (w_DECi),
        .i_count (w_icount)
    );

    comp_i u_comp_i (
        .i_count (w_icount),
        .z       (w_z)
    );

    sumador_comp u_sum (
        .R     (w_Rreg),
        .V     (V),
        .diff  (w_diff),
        .MSB_R (w_msb_r)
    );

    // CONTROL 

    control_div u_ctrl (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .msb_r (w_msb_r),
        .z     (w_z),
        .done  (done),
        .LDR   (w_LDR),
        .Q0    (w_Q0),
        .SH    (w_SH),
        .LDQ   (w_LDQ),
        .DECi  (w_DECi)
    );

    // Salidas 
    assign P = w_Qreg;
    assign R = w_Rreg;

endmodule
