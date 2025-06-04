`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2025 07:39:00 PM
// Design Name: 
// Module Name: testDFF
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



module testDFF();
    reg clk = 0;
    wire sclk;

    // Instantiate the module
    DFF uut (
        .clk(clk),
        .sclk(sclk)
    );

    // Clock generator: 10ns period (100 MHz)
    always #5 clk = ~clk;

endmodule




