`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 09:13:44 AM
// Design Name: 
// Module Name: nBitRCA
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


module nBitRCA #(parameter N=32)( input [N-1:0]A, B, output [N-1:0] sum, output  Cout);

wire [N:0] cout_tmp;
genvar i;
assign cout_tmp[0] = 0;

generate
    for (i = 0 ;i < N; i= i+1)
    begin
      FullAdder f (.A(A[i]), .B(B[i]), .cin(cout_tmp[i]), .sum(sum[i]), .cout(cout_tmp[i+1]));    
    end
endgenerate

assign Cout = cout_tmp[N];


endmodule


