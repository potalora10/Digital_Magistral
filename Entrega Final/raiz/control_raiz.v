`timescale 1ns/1ps
module control_raiz (
    input  wire clk,
    input  wire rst,     
    input  wire start,
    input  wire z,       

    output reg  done,
    output reg  LD,
    output reg  ADD,
    output reg  INC
);

    localparam [1:0] START_ST = 2'b00;
    localparam [1:0] CHECK_ST = 2'b01;
    localparam [1:0] ADD_ST   = 2'b10;
    localparam [1:0] DONE_ST  = 2'b11;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START_ST;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            START_ST: next_state = start ? CHECK_ST : START_ST;
            CHECK_ST: next_state = z     ? ADD_ST    : DONE_ST;
            ADD_ST:   next_state = CHECK_ST;
            DONE_ST:  next_state = START_ST;
            default:  next_state = START_ST;
        endcase
    end

    always @(*) begin
        done = 1'b0;
        LD   = 1'b0;
        ADD  = 1'b0;
        INC  = 1'b0;
        case (state)
            START_ST: begin
                LD = 1'b1;
            end
            CHECK_ST: ; // solo decide
            ADD_ST: begin
                ADD = 1'b1;
                INC = 1'b1;
            end
            DONE_ST: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end

endmodule
