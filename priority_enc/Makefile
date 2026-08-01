VERILATOR = verilator
FLAGS     = --binary --timing -Wall

.PHONY: all pe run_pe

all: pe 

pe:
	$(VERILATOR) $(FLAGS) priority_enc.sv priority_enc_tb.sv --top-module priority_enc_tb -o priority_enc_tb_sv

run_pe: pe
	./obj_dir/priority_enc_tb_sv

clean:
	rm -rf obj_dir

