# Building Ben Eater's VGA Breadboard Video Card on FPGA

![Main project image](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/vga_project.jpg?raw=true)

This project is an adaptation of Ben Eater's [VGA video card](https://eater.net/vga) circuit to an FPGA board. I strongly suggest that you watch the video tutorials first and study the circuit before undertaking this project, as the steps described in this article will not make sense without that context.

## Things You'll Need
For this project you need a FPGA development board and a VGA connector. The steps described below are those I took with a Xilinx-based FGPA board and IDE, Vivado. However, the source Verilog files should be usable with dev boards and IDE from other vendors.

The project shown in the introduction made use of the following hardware, which I strongly recommend:

- [Mercury 2 FPGA Development Board](https://www.micro-nova.com/mercury-2), from Micro Nova
- [VGA Connector](https://digilent.com/shop/pmod-vga-video-graphics-array/), from Digilent

I found Digilent's VGA connector particularly convenient as it already embeds the kind of resistor network that Ben used on his circuit to generate the color signals, and also a pair of '245 transceivers to buffer the FPGA output pins. The caveat is that whereas Ben used 2 bits for each color, this adapter expects 4 bits per color. As such, for the purpose of this project, I created a makeshift 'upscaler' module, which you will see in the instructions. If you stick to the regular VGA breakout module as shown in Ben's video (and web site), then you don't need that 'upscaler', but you may need to implement your own resistor ladder and buffering.

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

The view can be quite condensed given how busy the screen gets in the IDE. There is a button on the top right of the pane that allows you to undock the waveform window, and then you can use the zoom buttons in that window to get to the desired granularity. As you can see below, the simulation waveform looks pretty much exactly as you would see it on a logic analyzer. For bus-oriented (multiple bit) signals, like the output Q, Vivado will display the numerical value of the bit sequence at the top of the sequence, which is really convenient.

![Counter Simulation Waveform Expanded](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/counter_waveform_expanded.png?raw=true)

## Flip-Flops vs Latches

In order to latch decoded values from the counters, Ben used SR latches to record the proper intervals. My first attempts to code an SR latch in Verilog led to plenty of critical warnings about timings. While I eventually landed on the proper way to do it with the right documentation from Xilinx, I kept reading that FPGAs and latches are not best friends. So I decided to act on recommendations from several sources to use flip-flops, which are more native to FPGA constructs, instead of latches. As such, the next steps consists of creating and testing a reusable D flip-flop module.

In Vivado, import the source file 'flip_flop.v' as a 'design source'. As you can see in the snippet below the code is in many ways similar to the counter module, but with an d input and latching that input on the clock signal instead of incrementing the register. 

![Flip Flop Code](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/flip_flop_code.png?raw=true)

To view the elaborated design for the flip_flop, you need to tell Vivado that the 'top module' is flip_flop.v. As shown below, the top module is highlighted in bold on the sources pane. To designate the flip flop module as the top module, right-click on it and select 'set as top'. Then click on 'Open Elaborated Design'.

![Top Module](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/top_modules.png?raw=true)

I also created a test bench for the flip flop if you are interested. Import the file 'tb_flip_flop.v' as a simulation source, and designate it as 'top module' the same way you did in the previous step. Then click on 'Run Simulation > Run Behavioral Simulation' in the Flow Navigator pane.

## Building the HSYNC and VSYNC Circuits

The hsync module is the first to compose previously defined modules into a larger circuit. Import the file 'hsync.v' into Vivado as a design source, and set it as 'top module', as explained earlier, to make it the root entity. As you can see in the code below, the module basically follows Ben's design.

![HSync Module](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/hsync_code.png?raw=true)

A key discovery I made while coding this is that Verilog provides a very convenient way of decoding binary values. It comes in the form of a ternary condition expression. For instance, decoding the value of 200 from the 10-bit q signal is done with this statement:

```verilog:
assign h200_out = (q_out == 200) ? 1 : 0;
```

Opening up the elaborated design for the hsync module also brought a big surprise. I was expecting to see a bunch of AND gates to decode the various binary values needed for the intervals, but no, as you can see below the tool chain implemented that with mini-ROM modules!! I guess that makes sense given that I read that lookup tables were basic building blocks in FPGA to implement combinational logic.

![HSync Module Elaborated Design](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/hsync_elaborated_design.png?raw=true)

The simulation of the hsync module was a critical phase of the project as I wanted to measure timings for the hsync pulse (3.2 uS) as well as the overall horizontal blanking interval (6.2uS) and the whole line (26.4 uS). Running this simulation requires a change to simulation settings in Vivado, which by default limits the simulation to 1 uS. To do so, right-click on the 'Simulation' header in the Flow Navigator pane and select 'Simulation Settings...'. On the tab 'simulation', set the simulation time to 100 uS, as shown below.

![Simulation Settings](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/sim_settings.png?raw=true)

If you import the testbench, tb_hsync, and run the simulation after making it the top module, you will see that the requirement was met. There is a handy marker feature in the simulation window that facilitates such measurements.

![HSync Simulation](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/hsync_simulation.png?raw=true)

The VSYNC circuit is virtually identical to the one defined for HSYNC, with the exception that the values decoded for the purpose of the vsync pulse and vertical blanking intervals are different. Import the file 'vsync.h' as a design source at your convenience. A testbench is also provided, tb_vsync.h. If you intend to run the test bench, you will need to increase the simulation time limit once more. A limit of 40 ms would provide enough simulation time for 2 complete video frames.

## Creating a ROM Pre-Loaded with the Finch Image

One big question I had while coding this project was how the EEPROM Ben used in his VGA circuit to render the Finch image would translate in Verilog. I saw a bunch of examples showing the concepts of inferred RAM and pre-loading that with binary data, which I thought would be the way to go. However, it turns out that Vivado has a library of wizard-based IP component generators that handles that for you. The one caveat is that the memory loading facility expects a comma separated text file containing the binary data. Go figure. Pretty sure that a binary file could be loaded outside of that, but anyway, I ended up creating a script that would generate that text file from Ben's EEPROM binary file.

To create the ROM, click on "IP Catalog" in the Flow Navigator pane. This will bring up the "IP Catalog" tab. In the Search field, enter "ROM". The IP Wizard you are looking for is "Block Memory Generator", as shown below. Double-click on that to launch the wizard.

![ROM Step 1](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/rom_1.png?raw=true)

On the wizard, enter "rom_finch" as the component name. You can change that as long as you modify the main module accordingly in the steps to come. On the "Basic" tab, select "Single Port ROM" as the memory type, as shown below. You can leave the other options as they are.

![ROM Step 2](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/rom_2.png?raw=true)

On the "Port A Options" tab, enter "8" as the "Port A Width", and "32768" as "Port A Depth", as shown below. These are the width and depth of the standard EEPROM used on Ben's VGA circuit. You can leave the remaining options as they are.

[ROM Step 3](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/rom_3.png?raw=true)

On the "Other Options" tab, check the "Load Init File" checkbox, and hit the browse button to locate and select the file "finch.coe" provided in the Data folder of the source files, as shown below. You can leave the remaining options as they are.

[ROM Step 4](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/rom_4.png?raw=true)

Click on the "Summary Tab" and make sure that the information matches that shown below. You can expand the IP symbol on the left to reveal ports. As you can see, the structure of the ports is very much the same as a 32K EEPROM.

[ROM Step 5](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/rom_5.png?raw=true)

Click on "OK". On the "Generate Output Products" window, leave all options at their default values and hit the "Generate" button.

[ROM Step 6](https://github.com/The8BitEnthusiast/vga-on-fpga/blob/master/Graphics/rom_6.png?raw=true)

If all goes well, the wizard will generate the component and it will appear in the project sources pane.

## Creating the Clock Module

## Putting it All Together
