`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 08:37:28 AM
// Design Name: 
// Module Name: nBitALU
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


module nBitALU  #(parameter N = 32)(input [N-1:0] A, B, input [3:0] sel , output reg [N-1:0] ALUOutput , output Z);

wire [N-1:0]Sum;
reg [N-1:0]tempB ;

always @(*) begin
if (sel[2] == 0)
    tempB = B;
else if (sel[2] == 1)
    tempB = ~B+1;
end

nBitRCA rca(.A(A), .B(tempB), .sum(Sum),.Cout());


always @(*) begin
        case(sel)
            4'b0010: ALUOutput = Sum;    
            4'b0110: ALUOutput = Sum;    
            4'b0000: ALUOutput = A & B;    
            4'b0001: ALUOutput = A | B;    
            default: ALUOutput = 0;       
        endcase
    end

    assign Z = (ALUOutput == 0) ? 1 : 0;
    
endmodule
