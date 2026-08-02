VERILATOR = verilator
FLAGS = --binary --timing -Wall

.PHONY: all tl run_tl

all: tl

tl:
	$(VERILATOR) $(FLAGS) counter.sv traffic_light.sv traffic_light_tb.sv --top-module traffic_light_tb

run_tl:
	./obj_dir/Vtraffic_light_tb

clean:
	rm -rf obj_dir