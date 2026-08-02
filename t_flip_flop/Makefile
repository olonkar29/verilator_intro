VERILATOR = verilator
FLAGS     = --binary --timing -Wall

.PHONY: all tff run_tff

all: tff

tff:
	$(VERILATOR) $(FLAGS) tff.sv tff_tb.sv --top-module tff_tb

run_tff:
	./obj_dir/Vtff_tb

clean:
	rm -rf obj_dir