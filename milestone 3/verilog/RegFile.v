`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 09:57:07 AM
// Design Name: 
// Module Name: RegFile
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


module RegFile #(parameter N = 32) (input regWriteS, input clk, rst, input [4:0] readReg1, readReg2, writeReg, input [31:0]writeData, output [31:0] readData1, readData2);


reg [N-1:0] regfile [31:0];
integer i;

always @ (posedge clk,posedge rst) begin 
if (rst)begin
     for (i = 0; i < 32; i= i+1)
        regfile[i] = 0;
end
//else if (regWriteS == 1'b1 && writeReg != 0)
//    regfile[writeReg] = writeData;
end


always @ (negedge clk, posedge rst) begin 
if (regWriteS == 1'b1 && writeReg != 0)
    regfile[writeReg] = writeData;
end


assign readData1 = regfile[readReg1];
assign readData2 = regfile[readReg2];


endmodule
