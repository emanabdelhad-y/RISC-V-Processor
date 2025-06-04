`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025
// Design Name: 
// Module Name: ALUControlUnit
// Project Name: 
// Description: RISC-V ALU Control Unit
//////////////////////////////////////////////////////////////////////////////////

module ALUControlUnit (
    input  [3:0] ID_EX_Func,   // {funct7[5], funct3} ? [3] is funct7[5], [2:0] is funct3
    input  [2:0] ALUOp,        // 3-bit ALU operation code from main control unit
    output reg [3:0] ALUSel    // 4-bit ALU operation selector
);

// ALUOp encoding (example):
// 3'b000: Load/Store (Add)
// 3'b001: Branch
// 3'b010: R-type
// 3'b011: I-type
// 3'b100: LUI/AUIPC (default)
// ID_EX_Func encoding: {funct7[5], funct3} - 4 bits total

always @(*) begin
    case ({ALUOp, ID_EX_Func})
        // Load/Store: ALU always performs addition
        7'b000_xxxx: ALUSel = 4'b0000;

        // Branch: typically use subtraction (for comparison)
        7'b001_xxxx: ALUSel = 4'b0001;

        // R-type Instructions
        7'b010_0000: ALUSel = 4'b0000; // ADD
        7'b010_1000: ALUSel = 4'b0001; // SUB
        7'b010_0001: ALUSel = 4'b1001; // SLL
        7'b010_0010: ALUSel = 4'b1101; // SLT
        7'b010_0011: ALUSel = 4'b1111; // SLTU
        7'b010_0100: ALUSel = 4'b0111; // XOR
        7'b010_0101: ALUSel = 4'b1000; // SRL
        7'b010_1101: ALUSel = 4'b1010; // SRA
        7'b010_0110: ALUSel = 4'b0100; // OR
        7'b010_0111: ALUSel = 4'b0101; // AND

        // I-type Instructions
        7'b011_0000: ALUSel = 4'b0000; // ADDI
        7'b011_0001: ALUSel = 4'b1001; // SLLI
        7'b011_0010: ALUSel = 4'b1101; // SLTI
        7'b011_0011: ALUSel = 4'b1111; // SLTIU
        7'b011_0100: ALUSel = 4'b0111; // XORI
        7'b011_0101: ALUSel = 4'b1000; // SRLI
        7'b011_1101: ALUSel = 4'b1010; // SRAI
        7'b011_0110: ALUSel = 4'b0100; // ORI
        7'b011_0111: ALUSel = 4'b0101; // ANDI

        // Default: LUI/AUIPC or invalid
        default: ALUSel = 4'b0011;
    endcase
end

endmodule
