`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2022 03:32:40 PM
// Design Name: 
// Module Name: counter
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


module counter
    #(parameter BIT_WIDTH=4)
    (
    input clk,
    input rst_n,
    output [BIT_WIDTH-1:0] q
    );
    
    reg [BIT_WIDTH-1:0] q_int;
    
    // set initial conditions (for simulation only)
    initial
    begin
      q_int <= 0;
    end
    
    always @ (posedge clk, negedge rst_n) begin
        if (! rst_n)
            q_int <= 0;   // if reset is detected, set internal register to zero
        else
            q_int <= q_int + 1;   // otherwise increment count
    end
    
    assign q = q_int;
    
endmodule


