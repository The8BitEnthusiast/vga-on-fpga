`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2022 12:59:50 PM
// Design Name: 
// Module Name: tb_flip_flop
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


module tb_flip_flop;

    reg clk, rst_n, d;
    wire q;
    
    // Instantiate counter
    flip_flop ff0 ( .clk (clk),
                 .rst_n (rst_n),
                 .d (d),
                 .q (q));
    
    // set up the clock period             
    always #5 clk = ~clk;
    
    initial begin
    
        // initialize clock and reset
        clk <= 0;
        rst_n <= 0;
        
        #20 rst_n <= 1; d <= 0;  // disable reset and initialize d to zero
        
        #20 d <= 1;  // put value in
      
        #20 d <= 0;  // reset value
        
        #20 d <= 1;  // put value in
        
        #20 rst_n <= 0; // reset flip-flop
        
        #20 $finish;
    end

endmodule
