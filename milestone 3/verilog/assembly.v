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

//oputpu treg [6:0] LED_out
//output reg [12:0] SSD_out,
module assembly (output [3:0] Anode, input clk, rst, input SSdclk, input [3:0] ssdSel, input [1:0] ledSel, output reg [15:0] LEDs, output [6:0] LED_out);


wire [15:0] ledout;
wire  [12:0] SSD_out;
 
Four_Digit_Seven_Segment_Driver ssd (SSdclk, SSD_out, Anode, LED_out);

always@(*)begin
    LEDs <= ledout;
end


endmodule
