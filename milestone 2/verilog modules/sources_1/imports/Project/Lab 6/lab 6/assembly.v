`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 10:01:47 AM
// Design Name: 
// Module Name: assembly
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


module assembly (input SSdclk, input [12:0] num, output reg [3:0] ssdSel, output reg [6:0] LED_out);

Four_Digit_Seven_Segment_Driver ssd (SSdclk, num, Anode, LED_out);
RISCV riscv (clk, rst, LED_out, ledSel, ssdSel, ssd, SSdclk);


endmodule
