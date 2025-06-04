`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2025 07:35:44 PM
// Design Name: 
// Module Name: DFF
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


module DFF(

    input wire clk,       // Original fast clock
    output reg sclk = 0   // Slower clock (divided by 2)
);

    always @(posedge clk) begin
        sclk <= ~sclk;    // Toggle the slow clock on each rising edge
    end

endmodule



