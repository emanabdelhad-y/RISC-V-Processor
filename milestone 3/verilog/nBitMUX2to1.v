`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 09:04:10 AM
// Design Name: 
// Module Name: nBitMUX2to1
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


module nBitMUX2to1 #(parameter N = 8)(input [N-1:0]A, input [N-1:0] B, input s, output [N-1:0] C);
    genvar i;
	// Generate for loop to instantiate N times
	generate
		for (i = 0; i < N; i = i + 1) begin
          MUX2to1 mux (A[i], B[i], C[i], s );
		end
	endgenerate

endmodule
