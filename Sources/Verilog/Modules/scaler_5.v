`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2022 07:00:18 PM
// Design Name: 
// Module Name: scaler_5
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


module scaler (
    input en,
    input [1:0] d,
    output [3:0] q
    );
    
    // if the scaler is enabled, multiply the input by 5, or else just output 0.
    assign q = en ? (d * 5) : 4'b0000;
    
endmodule



