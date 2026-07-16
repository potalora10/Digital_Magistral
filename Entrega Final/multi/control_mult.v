module control_mult (
    input  wire clk,
    input  wire rst,     
    input  wire start,
    input  wire x,        
    input  wire z,        

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

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START_ST;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            START_ST:     next_state = start ? CHECK_B_ST : START_ST;
            CHECK_B_ST:   next_state = z     ? DONE_ST    : CHECK_LSB_ST;
            CHECK_LSB_ST: next_state = x     ? ADD_ST     : SHIFT_ST;
            ADD_ST:       next_state = SHIFT_ST;
            SHIFT_ST:     next_state = CHECK_B_ST;
            DONE_ST:      next_state = START_ST;
            default:      next_state = START_ST;
        endcase
    end

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
            CHECK_B_ST:   ; 
            CHECK_LSB_ST: ; 
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
