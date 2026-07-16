IVERILOG := iverilog
VVP      := vvp
GTKWAVE  := gtkwave

SOURCES  := reg_A.v reg_B.v comparador.v acumulador.v control_mult.v multiplicador.v
TB       := multiplicador_tb.v

OUT      := sim.out
VCD      := multiplicador_tb.vcd

.PHONY: all sim run wave clean

all: run

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
