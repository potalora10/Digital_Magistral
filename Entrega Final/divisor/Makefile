IVERILOG := iverilog
VVP      := vvp
GTKWAVE  := gtkwave

SOURCES  := reg_R.v reg_Q.v reg_i.v comp_i.v sumador_comp.v control_div.v divisor.v
TB       := divisor_tb.v

OUT      := sim.out
VCD      := divisor_tb.vcd

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
