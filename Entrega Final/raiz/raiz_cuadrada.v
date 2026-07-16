`timescale 1ns/1ps
module raiz_cuadrada (
    input  wire        clk,
    input  wire        rst,    
    input  wire        start,
    input  wire [15:0] X,
    output wire [15:0] Q,      
    output wire [15:0] Residuo, 
    output wire         done
);

    //Senales de control 
    wire w_LD, w_ADD, w_INC;

    // Senal de estado (Datapath -> Control) ----
    wire w_z;

    //Buses internos del datapath ----
    wire [15:0] w_Xacc;
    wire [15:0] w_D;
    wire [15:0] w_Q;

    // DATAPATH

    reg_D u_reg_D (
        .clk (clk),
        .add (w_ADD),
        .ld  (w_LD),
        .D   (w_D)
    );

    reg_X_acc u_reg_Xacc (
        .clk  (clk),
        .ld   (w_LD),
        .add  (w_ADD),
        .in_X (X),
        .D    (w_D),
        .X    (w_Xacc)
    );

    comp_raiz u_comp (
        .X (w_Xacc),
        .D (w_D),
        .z (w_z)
    );

    reg_Q_raiz u_reg_Q (
        .clk (clk),
        .ld  (w_LD),
        .inc (w_INC),
        .Q   (w_Q)
    );

    // CONTROl

    control_raiz u_ctrl (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .z     (w_z),
        .done  (done),
        .LD    (w_LD),
        .ADD   (w_ADD),
        .INC   (w_INC)
    );

    // ---- Salidas ----
    assign Q       = w_Q;
    assign Residuo = w_Xacc;

endmodule
