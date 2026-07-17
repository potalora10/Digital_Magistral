module control_unos (
    input  wire clk,
    input  wire rst,    
    input  wire start,
    input  wire lsb_a,  
    input  wire z,      

    output reg  done,
    output reg  SH,
    output reg  LD,
    output reg  INC
);

    localparam [2:0] START_ST      = 3'b000;
    localparam [2:0] CHECK_A_ST    = 3'b001;
    localparam [2:0] CHECK_LSB_ST  = 3'b010;
    localparam [2:0] SHIFT_ST      = 3'b011;
    localparam [2:0] INCREMENTO_ST = 3'b100;
    localparam [2:0] DONE_ST       = 3'b101;

    reg [2:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START_ST;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            START_ST:      next_state = start  ? CHECK_A_ST    : START_ST;
            CHECK_A_ST:    next_state = z      ? DONE_ST        : CHECK_LSB_ST;
            CHECK_LSB_ST:  next_state = lsb_a  ? INCREMENTO_ST  : SHIFT_ST;
            INCREMENTO_ST: next_state = SHIFT_ST;
            SHIFT_ST:      next_state = CHECK_A_ST;
            DONE_ST: begin
                if (start)
                    next_state = START_ST;   
                else
                    next_state = DONE_ST;  // 
            end
            default:       next_state = START_ST;
        endcase
    end

    always @(*) begin
        done = 1'b0;
        SH   = 1'b0;
        LD   = 1'b0;
        INC  = 1'b0;
        case (state)
            START_ST: begin
                LD = 1'b1;
            end
            CHECK_A_ST:   ; // solo decide
            CHECK_LSB_ST: ; // solo decide
            SHIFT_ST: begin
                SH = 1'b1;
            end
            INCREMENTO_ST: begin
                INC = 1'b1;
            end
            DONE_ST: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end

endmodule
