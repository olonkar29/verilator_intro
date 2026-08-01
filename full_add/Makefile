VERILATOR = verilator
FLAGS     = --binary --timing -Wall

.PHONY: all fa rca run_fa run_rca clean

all: fa rca

# --- Full Adder ---
fa:
	$(VERILATOR) $(FLAGS) full_adder.sv full_adder_tb.sv --top-module full_adder_tb

run_fa: fa
	./obj_dir/Vfull_adder_tb

# --- Ripple Carry Adder ---
rca:
	$(VERILATOR) $(FLAGS) full_adder.sv ripple_carry_adder.sv ripple_carry_adder_tb.sv --top-module ripple_carry_adder_tb

run_rca: rca
	./obj_dir/Vripple_carry_adder_tb

# --- Cleanup ---
clean:
	rm -rf obj_dir
