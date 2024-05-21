# RGB Mixer

This project consists of adjusting the light pulse intensity of a red, green, and blue LEDs. By putting them together, the light is combined and can be modified to show different RGB mixes.

# Architecture 

The top module is shown below and it consists of 3 sub modules (an additional clock divider module is included to reduce the clock frequency, in case of loading the design onto the icebreaker FPGA):

- Debouncer.
- Encoder. 
- Pulse width modulator (PWM).

image.jgp

So, each color channel takes two inputs (from a rotary encoder) which are debounced to correct the mechanical bouncing of the signal. Following, both inputs are combined and encoded to produce a value that determines the level of light intensity that the corresponding color channel will be producing. Finally, this value is set in the PWM, setting the width of the pulse that powers the LED.  Overall, adjusting the rotary encoder dims or brightnes the LED. 

Having three color channels, with two inputs each, the design has a total of 6 debounce modules, 3 encoders, and 3 PWMs.

## The Makefile

The Makefile automates the compilation process that tests the behavior of each module, including the top module. Comprisingly, it takes care of the simulation and verification processes. On the first step, iverilog produces two files , on the second step, Python's module cocotb takes the output files to produce the wave signal simulation and the verification of the designs with vvp that checks for the design's robustness and functionality with an specific testbench written for each of the modules.

image.jpg

## Testing on a FPGA

picture.jpg

The process of testing the design on an FPGA consists of:

- Synthesis.

- Mappinng.

- Place and route.

- Bitstream.

- Programing.

The "fpga" directory contains its own Makefile that automates the synthesis process to program the design on an icebreaker FPGA.

## License

This project is part of the Zero to ASIC Course. 

