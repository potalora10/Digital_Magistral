`timescale 1ns/1ps

module contador_unos_tb;

    reg         clk;
    reg         rst;
    reg         start;
    reg  [15:0] Ain;
    wire [4:0]  C;
    wire        done;

    integer pruebas = 0;
    integer errores = 0;

    contador_unos uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .A     (Ain),
        .C     (C),
        .done  (done)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    function [4:0] contar_unos;
        input [15:0] val;
        integer j;
        begin
            contar_unos = 5'd0;
            for (j = 0; j < 16; j = j + 1)
                if (val[j])
                    contar_unos = contar_unos + 5'd1;
        end
    endfunction

    task ejecutar_prueba(input [15:0] valA);
        reg [4:0] esperado;
        begin
            esperado = contar_unos(valA);

            @(posedge clk); #2;
            Ain   = valA;
            start = 1'b1;

            @(posedge clk); #2;
            start = 1'b0;

            wait (done == 1'b1);
            pruebas = pruebas + 1;

            if (C !== esperado) begin
                errores = errores + 1;
                $display("[%0t] FALLO -> A=%b : C=%0d (se esperaba %0d)",
                          $time, valA, C, esperado);
            end else begin
                $display("[%0t] OK    -> A=%b tiene %0d unos",
                          $time, valA, C);
            end

            @(posedge clk); #2;
        end
    endtask

    initial begin
        $dumpfile("contador_unos_tb.vcd");
        $dumpvars(0, contador_unos_tb);

        rst   = 1'b1;
        start = 1'b0;
        Ain   = 16'd0;

        #23;
        rst = 1'b0;

        ejecutar_prueba(16'h0000);
        ejecutar_prueba(16'hFFFF);
        ejecutar_prueba(16'h0001);
        ejecutar_prueba(16'h8000);
        ejecutar_prueba(16'hAAAA);
        ejecutar_prueba(16'h00FF);
        ejecutar_prueba(16'h1234);

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
