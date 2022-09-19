`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2022 05:35:14 PM
// Design Name: 
// Module Name: tb_vsync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_vsync(

    );
    
    reg clk;
    wire vsync;
    wire [9:0] q;
    wire vblank_n;
    
    always #50 clk = ~clk;
    
    vsync vsync0 ( .clk (clk), .vsync(vsync), .q (q), .vblank_n(vblank_n));
    
    initial begin
        clk <= 0;
        #100000 $finish;
    end
    
endmodule
