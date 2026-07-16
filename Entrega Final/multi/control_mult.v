// ============================================================
// control_mult.v
// Maquina de estados (tipo Moore) que implementa exactamente
// el diagrama de estados de la logica del multiplicador:
//
//   START     -- start=1 --> CHECK_B
//   CHECK_B   -- z=1     --> DONE
//   CHECK_B   -- z=0     --> CHECK_LSB
//   CHECK_LSB -- x=1     --> ADD
//   CHECK_LSB -- x=0     --> SHIFT
//   ADD       ------------> SHIFT
//   SHIFT     ------------> CHECK_B
//   DONE      ------------> START
//
// Salidas por estado (igual que en el diagrama):
//   START     : LD=1 RST=1 SH=0 ADD=0 DONE=0
//   CHECK_B   : LD=0 RST=0 SH=0 ADD=0 DONE=0
//   CHECK_LSB : LD=0 RST=0 SH=0 ADD=0 DONE=0
//   ADD       : LD=0 RST=0 SH=0 ADD=1 DONE=0
//   SHIFT     : LD=0 RST=0 SH=1 ADD=0 DONE=0
//   DONE      : LD=0 RST=0 SH=0 ADD=0 DONE=1
//
// Nota: RST (reset del acumulador P) se activa junto con LD en
// START, porque el diagrama no detalla una senal RST por estado
// pero si la muestra como salida del bloque Control hacia el
// Datapath; es en START donde deben inicializarse A, B y P.
// ============================================================
module control_mult (
    input  wire clk,
    input  wire rst,     // reset global sincrono (asincrono aqui)
    input  wire start,
    input  wire x,        // LSB(B), viene del COMP
    input  wire z,        // (B==0), viene del COMP

    output reg  done,
    output reg  LD,
    output reg  SH,
    output reg  ADD,
    output reg  RST
);

    localparam [2:0] START_ST     = 3'b000;
    localparam [2:0] CHECK_B_ST   = 3'b001;
    localparam [2:0] CHECK_LSB_ST = 3'b010;
    localparam [2:0] ADD_ST       = 3'b011;
    localparam [2:0] SHIFT_ST     = 3'b100;
    localparam [2:0] DONE_ST      = 3'b101;

    reg [2:0] state, next_state;

    // ---- Registro de estado ----
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START_ST;
        else
            state <= next_state;
    end

    // ---- Logica de proximo estado ----
    always @(*) begin
        case (state)
            START_ST:     next_state = start ? CHECK_B_ST : START_ST;
            CHECK_B_ST:   next_state = z     ? DONE_ST    : CHECK_LSB_ST;
            CHECK_LSB_ST: next_state = x     ? ADD_ST     : SHIFT_ST;
            ADD_ST:       next_state = SHIFT_ST;
            SHIFT_ST:     next_state = CHECK_B_ST;
            DONE_ST: begin
                if (start)
                    next_state = START_ST;   
                else
                    next_state = DONE_ST;  // 
            end
            default:      next_state = START_ST;
        endcase
    end

    // ---- Logica de salida (Moore: depende solo del estado) ----
    always @(*) begin
        done = 1'b0;
        LD   = 1'b0;
        SH   = 1'b0;
        ADD  = 1'b0;
        RST  = 1'b0;
        case (state)
            START_ST: begin
                LD  = 1'b1;
                RST = 1'b1;
            end
            CHECK_B_ST:   ; // sin salidas activas, solo decide
            CHECK_LSB_ST: ; // sin salidas activas, solo decide
            ADD_ST: begin
                ADD = 1'b1;
            end
            SHIFT_ST: begin
                SH = 1'b1;
            end
            DONE_ST: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end

endmodule
