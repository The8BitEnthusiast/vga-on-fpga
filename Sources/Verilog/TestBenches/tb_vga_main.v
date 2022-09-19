`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2022 01:29:39 PM
// Design Name: 
// Module Name: tb_vga_main
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


module tb_vga_main(

    );

    reg clk;
    wire hsync, vsync;
    wire [3:0] red; 
    wire [3:0] blue;
    wire [3:0] green;

    vga_main vga0 ( .clk(clk), .io({red, green, blue, vsync, hsync})); 
    
    // 50 Mhz clock (20 ns period, so 10 ns between state changes)
    // NOTE: adjust as required based on your dev board's own clock
    always #10 clk = ~clk;

    initial begin
        clk <= 0;
    end

endmodule


