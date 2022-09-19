`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2022 02:25:25 PM
// Design Name: 
// Module Name: flip_flop
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


module flip_flop(
    input clk,
    input rst_n,
    input d,
    output q
    );
    
    // internal register
    reg q_int;
    
    // define initialization sequence (for simulation only)
    initial
    begin
        q_int <= 0;
    end
    
    // detect positive edge of clock or negative edge of reset line
    always @ (posedge clk, negedge rst_n)
    begin
        if (!rst_n)
            q_int <= 0;  // set internal register to zero if reset
        else
            q_int <= d;  // set internal register to input d
    end
    
    assign q = q_int;  // set output signal
    
endmodule




