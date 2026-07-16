IVERILOG := iverilog
VVP      := vvp
GTKWAVE  := gtkwave

SOURCES  := reg_X_acc.v reg_D.v reg_Q.v comp.v control_raiz.v raiz_cuadrada.v
TB       := raiz_cuadrada_tb.v

OUT      := sim.out
VCD      := raiz_cuadrada_tb.vcd

.PHONY: all sim run wave clean

all: run

sim: $(OUT)

$(OUT): $(SOURCES) $(TB)
	$(IVERILOG) -g2012 -o $(OUT) $(SOURCES) $(TB)

run: sim
	$(VVP) $(OUT)

wave: run
	$(GTKWAVE) $(VCD) &

clean:
	rm -f $(OUT) $(VCD)
