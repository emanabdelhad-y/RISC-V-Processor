`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 08:06:03 PM
// Design Name: 
// Module Name: nBit4by1MUX
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

module MUX4By1NBit # (parameter N = 32)(
    input [N-1:0] x0,
    input [N-1:0] x1,
    input [N-1:0] x2,
    input [N-1:0] x3,
    input [1:0] s,
    output [N-1:0] final
);
    assign final = s[1] ? (s[0] ? x3 : x2) : (s[0] ? x1 : x0);

endmodule