`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 09:13:23 AM
// Design Name: 
// Module Name: NBitShiftLeft
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


module NBitShiftLeft #(parameter N=32)(input [N-1:0] A, output [N-1:0]C);

assign C = {A[N-2:0], 1'b0};

endmodule
