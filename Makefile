# COCOTB variables
export COCOTB_REDUCED_LOG_FMT=1

all: test_encoder test_debounce test_pwm test_rgb_mixer

# if you run rules with NOASSERT=1 it will set PYTHONOPTIMIZE, which turns off assertions in the tests
test_top:
	echo "the top module was renamed to rgb_mixer. Please run make test_rgb_mixer instead"

test_rgb_mixer:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s rgb_mixer -s dump -g2012 src/rgb_mixer.v test/dump_rgb_mixer.v src/ src/encoder.v src/debounce.v src/pwm.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_rgb_mixer vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp

test_encoder:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s encoder -s dump -g2012 test/dump_encoder.v src/encoder.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_encoder vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp

test_pwm:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s pwm -s dump -g2012 src/pwm.v test/dump_pwm.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_pwm vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp

test_debounce:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s debounce -s dump -g2012 src/debounce.v test/dump_debounce.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_debounce vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp

show_%: %.vcd %.gtkw
	gtkwave $^

show_synth_%: src/%.v
	yosys -p "read_verilog $<; proc; opt; show -colors 2 -width -signed"

               

