module control_div (
    input  wire clk,
    input  wire rst,     
    input  wire start,
    input  wire msb_r, 
    input  wire z,     

    output reg  done,
    output reg  LDR,
    output reg  Q0,
    output reg  SH,
    output reg  LDQ,
    output reg  DECi
);

    localparam [2:0] START_ST   = 3'b000;
    localparam [2:0] CHECK_I_ST = 3'b001;
    localparam [2:0] SHIFT_ST   = 3'b010;
    localparam [2:0] CHECK_R_ST = 3'b011;
    localparam [2:0] ADD_ST     = 3'b100;
    localparam [2:0] DONE_ST    = 3'b101;

    reg [2:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START_ST;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            START_ST:   next_state = start ? CHECK_I_ST : START_ST;
            CHECK_I_ST: next_state = z     ? DONE_ST     : SHIFT_ST;
            SHIFT_ST:   next_state = CHECK_R_ST;
            CHECK_R_ST: next_state = msb_r ? ADD_ST      : CHECK_I_ST;
            ADD_ST:     next_state = CHECK_I_ST;
            DONE_ST:    begin
                if (start)
                    next_state = START_ST;   
                else
                    next_state = DONE_ST;  // 
            end
            default:    next_state = START_ST;
        endcase
    end

    always @(*) begin
        done = 1'b0;
        LDR  = 1'b0;
        Q0   = 1'b0;
        SH   = 1'b0;
        LDQ  = 1'b0;
        DECi = 1'b0;
        case (state)
            START_ST: begin
                LDQ = 1'b1;
            end
            CHECK_I_ST: ; 
            SHIFT_ST: begin
                SH   = 1'b1;
                DECi = 1'b1;
            end
            CHECK_R_ST: ; 
            ADD_ST: begin
                LDR = 1'b1;
                Q0  = 1'b1;
            end
            DONE_ST: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end

endmodule
