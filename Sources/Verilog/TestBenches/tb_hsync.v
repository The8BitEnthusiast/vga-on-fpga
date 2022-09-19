`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2022 08:48:51 AM
// Design Name: 
// Module Name: tb_hsync
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


module tb_hsync(

    );
    
    reg clk;
    wire hsync;
    wire h264;
    wire hblank_n;
    
    always #50 clk = ~clk;
    
    hsync hsync0 ( .clk (clk), .hsync(hsync), .h264(h264), .hblank_n(hblank_n));
    
    initial begin
        clk <= 0;
        #100000 $finish;
    end
    
endmodule
