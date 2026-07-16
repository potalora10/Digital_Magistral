`timescale 1ns/1ps

module raiz_cuadrada_tb;

    reg         clk;
    reg         rst;
    reg         start;
    reg  [15:0] Xin;
    wire [15:0] Q;
    wire [15:0] Residuo;
    wire        done;

    integer pruebas = 0;
    integer errores = 0;

    raiz_cuadrada uut (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .X       (Xin),
        .Q       (Q),
        .Residuo (Residuo),
        .done    (done)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    function [15:0] raiz_entera;
        input [15:0] val;
        reg [15:0] n;
        begin
            n = 16'd0;
            while ((n + 16'd1) * (n + 16'd1) <= val)
                n = n + 16'd1;
            raiz_entera = n;
        end
    endfunction

    task ejecutar_prueba(input [15:0] valX);
        reg [15:0] esperadoQ;
        reg [15:0] esperadoR;
        begin
            esperadoQ = raiz_entera(valX);
            esperadoR = valX - (esperadoQ * esperadoQ);

            @(posedge clk); #2;
            Xin   = valX;
            start = 1'b1;

            @(posedge clk); #2;
            start = 1'b0;

            wait (done == 1'b1);
            pruebas = pruebas + 1;

            if (Q !== esperadoQ || Residuo !== esperadoR) begin
                errores = errores + 1;
                $display("[%0t] FALLO -> X=%0d : Q=%0d Residuo=%0d (se esperaba Q=%0d R=%0d)",
                          $time, valX, Q, Residuo, esperadoQ, esperadoR);
            end else begin
                $display("[%0t] OK    -> raiz(%0d) = %0d, residuo %0d",
                          $time, valX, Q, Residuo);
            end

            @(posedge clk); #2;
        end
    endtask

    // Secuencia principal 
    initial begin
        $dumpfile("raiz_cuadrada_tb.vcd");
        $dumpvars(0, raiz_cuadrada_tb);

        rst   = 1'b1;
        start = 1'b0;
        Xin   = 16'd0;

        #23;
        rst = 1'b0;

        ejecutar_prueba(16'd0);
        ejecutar_prueba(16'd1);
        ejecutar_prueba(16'd10);
        ejecutar_prueba(16'd16);
        ejecutar_prueba(16'd99);
        ejecutar_prueba(16'd255);
        ejecutar_prueba(16'd2000);

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
        #200000;
        $display("ERROR: TIMEOUT - la simulacion no termino a tiempo");
        $finish;
    end

endmodule
