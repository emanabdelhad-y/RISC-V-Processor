`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 10:56:52 AM
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(input [31:0]inst, output [31:0] gen);

wire [6:0] opcode;
reg [11:0] imm;

assign opcode = inst[6:0];

assign gen = {{20{imm[11]}}, imm};

always@(*) begin
if (opcode[6:5] == 2'b11) //beq
    imm = {inst[31], inst[7], inst[30:25], inst[11:8]};
else if(opcode[6:5] == 2'b00) //lw
    imm = inst[31:20];
else if(opcode[6:5] == 2'b01) //sw
    imm = {inst[31:25], inst[11:7]};
    
    
    

end


endmodule
