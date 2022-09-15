# Building Ben Eater's VGA Breadboard Video Card on FPGA

![Main project image](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/vga_project.jpg?raw=true)

This project is an adaptation of Ben Eater's [VGA video card](https://eater.net/vga) circuit to an FPGA board. I strongly suggest that you watch the video tutorials first and study the circuit before undertaking this project, as the steps described in this article will not make sense without that context.

## Things You'll Need
For this project you need a FPGA development board and a VGA connector. The steps described below are those I took with a Xilinx-based FGPA board and IDE, Vivado. However, the source Verilog files should be usable with dev boards and IDE from other vendors.

The project shown in the introduction made use of the following hardware, which I strongly recommend:

- [Mercury 2 FPGA Development Board](https://www.micro-nova.com/mercury-2), from Micro Nova
- [VGA Connector](https://digilent.com/shop/pmod-vga-video-graphics-array/), from Digilent

I found Digilent's VGA connector particular convenient as it already embeds the kind of resistor network that Ben used on his circuit to generate the color signals, and also a pair of '245 transceivers to buffer the FPGA output pins. The caveat is that whereas Ben used 2 bits for each color, this adapter expects 4 bits per color. As such, for the purpose of this project, I created a makeshift 'upscaler' module, which you will see in the instructions. If you stick to the regular VGA breakout module as shown in Ben's video (and web site), then you don't need that 'upscaler', but you may need to implement your own resistor ladder and buffering.

## Before You Begin
The instructions that follow do not go over the basic installation and use of the Vivado IDE. It is assumed that you have already done at least a basic tutorial (e.g. LED blink). To undertake this project, you should know how to create a blank project, create a source file, and deploy a basic circuit on the development board you have purchased.

## Defining a Reusable Counter Module
As a first step, create a new blank project in Vivado, specifying the FPGA part/dev board you will be using.

The first module to be created is a binary counter, which is used in both HSYNC and VSYNC circuit. From the source files downloaded from github, import the Verilog file "counter.v" as a 'design source file' into the Vivado project. As you can see below, there is not much to it. But one Verilog feature I wanted to try was "parameterized ports", which basically allows you to specify the bit width of a port at instantiation time. This will be put to use on the hsync and vsync circuits, which both have a counter, but with a different bit count.

![Counter Circuit](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/counter_code.png?raw=true)

Part of the FPGA workflow is for the tool chain to translate the Verilog code into a Register Transfer Level (RTL) design. Not sure where the name came from, but basically the tool chain creates a circuit with basic building blocks (e.g. flip-flops, gates, etc...) that will then be synthesized for hardware implementation. To view the RTL design, click on the "Open Elaborated Design" link in Vivado's workflow window. This is what it should look like:

![Counter Elaborated Design](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/counter_elaborated_design.png?raw=true)

I found this view fascinating. The tool chain interpreted the code as a basic state machine... a D flip-flop, and an adder to add 1 on each clock cycle.

Another major step that I found invaluable is the simulation of the circuit. Coming from the software side, this is the FPGA version of a unit and integration test framework. I have created a simple 'test bench' for each module. To simulate this circuit, import the file 'tb_counter' as a 'simulation source' in Vivado.  As you can see below, a clock with a period of 10 ns (10 Mhz frequency) is setup, and then stimulus is applied at different timings.

![Counter Testbench Code](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/counter_testbench_code.png?raw=true)

Then initiate the simulation by clicking on the "Run Simulation" link in Vivado's. This will initiate the simulation and a new waveform tab will appear on the right, as shown below. 

![Counter Simulation Waveform](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/counter_waveform_docked.png?raw=true)

The view can be quite condensed given how busy the screen gets in the IDE. There is a button on the top right of the pane that allows you to undock the waveform window, and then you can use the zoom buttons in that window to get to the desired granularity. As you can see below, the simulation waveform looks pretty much exactly as you would see it on a logic analyzer. For bus-oriented (multiple bit) signals, like the output Q, Vivado will display the numerical value of the bit sequence at the top of the bit sequence, which is really convenient.

![Counter Simulation Waveform Expanded](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/counter_waveform_expanded.png?raw=true)

## Building the HSYNC Circuit

## Building the VSYNC Circuit

## Creating a ROM Pre-Loaded with the Finch Image

## Creating the Clock Module

## Putting it All Together
