VERILATOR = verilator
FLAGS     = --binary --timing -Wall

.PHONY: all counter run_counter

all: counter

counter:
	verilator --binary --timing -Wall -Wno-BLKSEQ counter.sv counter_tb.sv --top-module counter_tb -o counter_tb

run_counter:
	./obj_dir/counter_tb

clean:
	rm -rf obj_dir