`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2022 07:05:32 PM
// Design Name: 
// Module Name: tb_scaler_5
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


module tb_scaler_5(

    );


    reg [1:0] d;
    wire [3:0] q;

    scaler_5 scaler0 (.d(d), .q(q));

    initial begin
        d <= 0;
        #10 d <= 2'b01;
        #10 d <= 2'b10;
        #10 d <= 2'b11;
        #10 $finish;
    end

endmodule
