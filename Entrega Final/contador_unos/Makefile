IVERILOG := iverilog
VVP      := vvp
GTKWAVE  := gtkwave

SOURCES  := reg_A.v comp.v reg_C.v control_unos.v contador_unos.v
TB       := contador_unos_tb.v

OUT      := sim.out
VCD      := contador_unos_tb.vcd

.PHONY: all sim run wave clean

all: run

# Compila todo el diseno + testbench
sim: $(OUT)

$(OUT): $(SOURCES) $(TB)
	$(IVERILOG) -g2012 -o $(OUT) $(SOURCES) $(TB)

# Compila (si es necesario) y ejecuta la simulacion
run: sim
	$(VVP) $(OUT)

# Ejecuta la simulacion y abre las formas de onda
wave: run
	$(GTKWAVE) $(VCD) &

# Limpia los artefactos de simulacion
clean:
	rm -f $(OUT) $(VCD)
