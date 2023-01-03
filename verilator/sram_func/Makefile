TOP_NAME := mycpu_top
SRC_DIR  := ../../mycpu
INC_FILE := $(shell find $(SRC_DIR) -name '*.svh') $(shell find $(SRC_DIR) -name '*.vh') $(shell find $(SRC_DIR) -name '*.v') $(shell find $(SRC_DIR) -name '*.sv')
INC_DIR	 := $(addprefix -I, $(shell find $(SRC_DIR) -type d))
.PHONY: clean dev wave

obj_dir/V$(TOP_NAME): src/* $(INC_FILE)
	verilator --cc -Wno-fatal --exe --trace --trace-structs --build src/sim_nscscc_sram.cpp $(INC_FILE) $(INC_DIR) --top $(TOP_NAME) -j `nproc`

dev:
	./obj_dir/V$(TOP_NAME)
clean:
	rm -rf obj_dir

wave:
	gtkwave.exe -g trace.vcd

