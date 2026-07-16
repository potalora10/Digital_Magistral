`timescale 1ns/1ps

module divisor_tb;

    reg         clk;
    reg         rst;
    reg         start;
    reg  [15:0] Qin;
    reg  [15:0] Vin;
    wire [15:0] P;
    wire [15:0] R;
    wire        done;

    integer pruebas = 0;
    integer errores = 0;

    divisor uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .Q     (Qin),
        .V     (Vin),
        .P     (P),
        .R     (R),
        .done  (done)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    task ejecutar_prueba(input [15:0] valQ, input [15:0] valV);
        reg [15:0] esperadoP;
        reg [15:0] esperadoR;
        begin
            esperadoP = valQ / valV;
            esperadoR = valQ % valV;

            @(posedge clk); #2;
            Qin   = valQ;
            Vin   = valV;
            start = 1'b1;

            @(posedge clk); #2;
            start = 1'b0;

            wait (done == 1'b1);
            pruebas = pruebas + 1;

            if (P !== esperadoP || R !== esperadoR) begin
                errores = errores + 1;
                $display("[%0t] FALLO -> Q=%0d V=%0d : P=%0d R=%0d (se esperaba P=%0d R=%0d)",
                          $time, valQ, valV, P, R, esperadoP, esperadoR);
            end else begin
                $display("[%0t] OK    -> Q=%0d / V=%0d = P=%0d resto %0d",
                          $time, valQ, valV, P, R);
            end

            @(posedge clk); #2;
        end
    endtask

    initial begin
        $dumpfile("divisor_tb.vcd");
        $dumpvars(0, divisor_tb);

        rst   = 1'b1;
        start = 1'b0;
        Qin   = 16'd0;
        Vin   = 16'd0;

        #23;
        rst = 1'b0;

        ejecutar_prueba(16'd10,    16'd3);
        ejecutar_prueba(16'd0,     16'd5);
        ejecutar_prueba(16'd100,   16'd1);
        ejecutar_prueba(16'd7,     16'd7);
        ejecutar_prueba(16'd255,   16'd16);
        ejecutar_prueba(16'd1,     16'd2);
        ejecutar_prueba(16'd65535, 16'd3);

        #40;
        $display("--------------------------------------------------");
        if (errores == 0)
            $display("RESULTADO: TODAS LAS PRUEBAS PASARON (%0d/%0d)", pruebas, pruebas);
        else
            $display("RESULTADO: %0d de %0d PRUEBAS FALLARON", errores, pruebas);
        $display("--------------------------------------------------");

        $finish;
    end

    // ---- Watchdog de seguridad (evita simulacion colgada) ----
    initial begin
        #100000;
        $display("ERROR: TIMEOUT - la simulacion no termino a tiempo");
        $finish;
    end

endmodule
