`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2022 04:19:31 PM
// Design Name: 
// Module Name: hsync
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


module hsync(
    input clk,
    output hsync,
    output hblank_n,
    output h264,
    output [9:0] q
    );
    
    // define wires
    wire [9:0] q_out;
    wire h200_out, h210_out, h242_out, h264_out;
    wire hsync_out, hblank_out;
  
    // define 10 bit counter
    counter #(.BIT_WIDTH(10)) c0 (.clk(clk), .rst_n(h264_out), .q(q_out));
    
    // decode binary values 200,210,242 and 264
    assign h200_out = (q_out == 200) ? 1 : 0;   // h200 is active high
    assign h210_out = (q_out == 210) ? 1 : 0;   // h210 is active high
    assign h242_out = (q_out == 242) ? 0 : 1;   // h242 is active low
    assign h264_out = (q_out == 264) ? 0 : 1;   // h264 is active low
    
    // flip flops for latching hsync and hblank interval signals
    flip_flop hsync_ff (.clk(h210_out), .d (1'b1), .rst_n (h242_out), .q (hsync_out));
    flip_flop hblank_ff (.clk(h200_out), .d (1'b1), .rst_n (h264_out), .q (hblank_out));
    
    // define output signals
    assign h264 = h264_out;
    assign hsync = hsync_out;
    assign hblank_n = ~ hblank_out;
    assign q = q_out;
    
endmodule




