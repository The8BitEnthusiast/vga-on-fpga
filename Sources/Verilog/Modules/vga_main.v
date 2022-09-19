`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2022 11:42:10 AM
// Design Name: 
// Module Name: vga_main
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


module vga_main(
        input clk,
        output [13:0] io
    );
    
    wire pixelclk;
    wire hsync, h264, hblank_n, vsync, vblank_n;
    wire [9:0] vq;
    wire [9:0] hq;
    wire [7:0] romout;
    wire blank;
    
    // assemble building blocks
    clk_wiz_0 clk10 (.clk_in (clk), .clk_out (pixelclk), .reset(1'b0));
    hsync hsync0 (.clk (pixelclk), .hsync(hsync), .hblank_n(hblank_n), .h264(h264), .q(hq));
    vsync vsync0 (.clk (h264), .vsync(vsync), .vblank_n(vblank_n), .q(vq));
    rom_finch rom0 (.clka(clk), .addra({1'b0,vq[9:3],hq[7:1]}), .douta(romout), .ena(1'b1));

    assign blank = hblank_n & vblank_n;

    // add upscalers to convert 2-bit colour outputs to 4 bits
    scaler scaler_blue (.d({romout[1:0]}),.q({io[5:2]}), .en(blank));
    scaler scaler_green (.d({romout[3:2]}) , .q({io[9:6]}), .en(blank));
    scaler scaler_red (.d({romout[5:4]}) , .q({io[13:10]}), .en(blank));
    
    // assign I/O outputs for sync signals
    assign io [0] = hsync;
    assign io [1] = vsync;
    
endmodule


