`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 11:08:09 AM
// Design Name: 
// Module Name: ALUControlUnit
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


module ALUControlUnit(input [31:0]inst , input [2:0]ALUOp, output reg[3:0] ALUSel );

always @ (*) begin

    if (ALUOp == 3'b000 && inst[14:12] == 3'bxxx && inst[30] == 1'bx) //load and store
        ALUSel = 4'b0000; 
    else if (ALUOp == 3'b001 && inst[14:12] == 3'bxxx && inst[30] == 1'bx) //branch
        ALUSel = 4'b0001; 
//R    
    else if (ALUOp == 3'b010 && inst[14:12] == 3'b000 && inst[30] == 0) //add D 
        ALUSel = 4'b0000; 
    else if (ALUOp == 3'b010 && inst[14:12] == 3'b000 && inst[30] == 0) //sub D
        ALUSel = 4'b0001;
    else if (ALUOp == 3'b010 && inst[14:12] == 3'b001 && inst[30] == 1'bx) //sll
        ALUSel = 4'b1001;
    else if (ALUOp == 3'b101 && inst[14:12] == 3'b101 && inst[30] == 0) //srl
        ALUSel = 4'b1000;
    else if (ALUOp == 3'b101 && inst[14:12] == 3'b101 && inst[30] == 1) //sra
        ALUSel = 4'b1010;
    else if (ALUOp == 3'b010 && inst[14:12] == 3'b010 && inst[30] == 1'bx) //slt
        ALUSel = 4'b1101;
    else if (ALUOp == 3'b010 && inst[14:12] == 3'b011 && inst[30] == 1) //sltu
        ALUSel = 4'b1111;
//I        
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b000) //addi
        ALUSel = 4'b0000;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b100 && inst[30] == 0) //xori
        ALUSel = 4'b0111;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b110 && inst[30] == 0) //ori
        ALUSel = 4'b0100;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b111 && inst[30] == 1) //andi
        ALUSel = 4'b0101;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b001 && inst[30] == 1) //slli
        ALUSel = 4'b1001;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b101 && inst[30] == 0) //srli
        ALUSel = 4'b1000;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b101 && inst[30] == 1) //srai
        ALUSel = 4'b1010;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b010 && inst[30] == 0) //slti
        ALUSel = 4'b1101;
    else if (ALUOp == 3'b011 && inst[14:12] == 3'b011 && inst[30] == 1) //sltiu
        ALUSel = 4'b1111;
        
    else if (ALUOp == 3'b100 && inst[14:12] == 3'bxxx && inst[30] == 1'bx) //lui
        ALUSel = 4'b0011;
    else if (ALUOp == 3'b000 && inst[14:12] == 3'bxxx && inst[30] == 1'bx) //auipc
        ALUSel = 4'b0011;
        
end

endmodule
