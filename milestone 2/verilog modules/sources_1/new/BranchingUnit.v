`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2025 12:01:44 PM
// Design Name: 
// Module Name: BranchingUnit
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


module BranchingUnit(
input cf, zf, vf, sf, branch,
input [2:0] func3,
output reg resBranch
);
always @(*) begin
     if (branch) begin
            case(func3)
                3'b000: resBranch = zf;             // BEQ
                3'b001: resBranch = ~zf;            // BNE
                3'b100: resBranch = (sf != vf);  //BLT
                3'b101: resBranch = (sf == vf);   //BGE         
                3'b110: resBranch = ~cf;            // BLTU         
                3'b111: resBranch = cf;             // BGEU    
                default: resBranch = 1'b0;
            endcase
        end
        else resBranch = 1'b0;
    
    end

endmodule
