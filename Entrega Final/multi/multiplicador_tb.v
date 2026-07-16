`timescale 1ns/1ps

module multiplicador_tb;

    reg         clk;
    reg         rst;
    reg         start;
    reg  [15:0] A;
    reg  [15:0] B;
    wire [31:0] P;
    wire        done;

    integer pruebas = 0;
    integer errores = 0;

    multiplicador uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .A     (A),
        .B     (B),
        .P     (P),
        .done  (done)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    task ejecutar_prueba(input [15:0] valA, input [15:0] valB);
        reg [31:0] esperado;
        begin
            esperado = valA * valB;

            @(posedge clk); #2;
            A     = valA;
            B     = valB;
            start = 1'b1;

            @(posedge clk); #2;
            start = 1'b0;

            wait (done == 1'b1);
            pruebas = pruebas + 1;

            if (P !== esperado) begin
                errores = errores + 1;
                $display("[%0t] FALLO -> A=%0d B=%0d : P=%0d (se esperaba %0d)",
                          $time, valA, valB, P, esperado);
            end else begin
                $display("[%0t] OK    -> A=%0d x B=%0d = %0d",
                          $time, valA, valB, P);
            end

            @(posedge clk); #2;
        end
    endtask

    initial begin
        $dumpfile("multiplicador_tb.vcd");
        $dumpvars(0, multiplicador_tb);

        rst   = 1'b1;
        start = 1'b0;
        A     = 16'd0;
        B     = 16'd0;

        #23;
        rst = 1'b0;

        ejecutar_prueba(16'd5,     16'd3);
        ejecutar_prueba(16'd0,     16'd10);
        ejecutar_prueba(16'd10,    16'd0);
        ejecutar_prueba(16'd1,     16'd1);
        ejecutar_prueba(16'd255,   16'd255);
        ejecutar_prueba(16'd12345, 16'd6789);
        ejecutar_prueba(16'd65535, 16'd65535);

        #40;
        $display("--------------------------------------------------");
        if (errores == 0)
            $display("RESULTADO: TODAS LAS PRUEBAS PASARON (%0d/%0d)", pruebas, pruebas);
        else
            $display("RESULTADO: %0d de %0d PRUEBAS FALLARON", errores, pruebas);
        $display("--------------------------------------------------");

        $finish;
    end

    initial begin
        #100000;
        $display("ERROR: TIMEOUT - la simulacion no termino a tiempo");
        $finish;
    end

endmodule
