`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2022 03:38:32 PM
// Design Name: 
// Module Name: tb_counter
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


module tb_counter;

    reg clk;
    reg rst_n;
    wire [7:0] q;
    
    // Instantiate counter
    counter #(.BIT_WIDTH(8)) c0 ( .clk (clk),
                 .rst_n (rst_n),
                 .q (q));
    
    // set up the clock period             
    always #5 clk = ~clk;
    
    initial begin
    
        // initialize clock and reset counter
        clk <= 0;
        rst_n <= 0;
        
        #20 rst_n <= 1;  // start count
        
        #350 rst_n <= 0; // reset counter
        
        #20 rst_n <= 1;  // start count again
        
        #100 $finish;
    end

endmodule



