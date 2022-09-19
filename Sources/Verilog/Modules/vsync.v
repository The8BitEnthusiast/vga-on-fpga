`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2022 05:14:41 PM
// Design Name: 
// Module Name: vsync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision: 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vsync(
    input clk,
    output vsync,
    output vblank_n,
    output [9:0] q
    );
    
    wire [9:0] q_out;
    wire v600_out;
    wire v601_out;
    wire v605_out;
    wire v628_out;
    
    wire vsync_out;
    wire vblank_out;
  
    // define 10 bit counter
    counter #(.BIT_WIDTH(10)) c0 (.clk(clk), .rst_n(v628_out), .q(q_out));
    
    // decode binary values 600, 601, 605, 628
    assign v600_out = (q_out == 600) ? 1 : 0;
    assign v601_out = (q_out == 601) ? 1 : 0;
    assign v605_out = (q_out == 605) ? 0 : 1;
    assign v628_out = (q_out == 628) ? 0 : 1;
    
    // flip flops for latching hsync and hblank signals
    flip_flop vsync_ff (.clk(v601_out), .d (1'b1), .rst_n (v605_out), .q (vsync_out));
    flip_flop vblank_ff (.clk(v600_out), .d (1'b1), .rst_n (v628_out), .q (vblank_out));
    
    // define output signals
    assign vsync = vsync_out;
    assign vblank_n = ~ vblank_out;
    assign q = q_out;
endmodule
