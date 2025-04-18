`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2025 06:45:22 PM
// Design Name: 
// Module Name: Shifter_Risc_V
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


module shifter(
    input  wire [31:0] a,
    input  wire [4:0]  shamt,
    input  wire [1:0]  type, // Determines shift type
    output reg  [31:0] r
);
    always @* begin
        case (type)
            2'b00: r = a >> shamt; // Logical right shift (SRL)
            2'b01: r = a << shamt; // Logical left shift (SLL)
            2'b10: r = $signed(a) >>> shamt; // Arithmetic right shift (SRA)
            default: r = a; // Default case (NOP)
        endcase
    end
endmodule

