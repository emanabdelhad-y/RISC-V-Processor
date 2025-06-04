`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Module Name: controlUnit
// Description: Generates control signals based on opcode
//////////////////////////////////////////////////////////////////////////////////

module controlUnit (
    input  [31:0] inst,
    output reg branch,
    output reg memRead,
    output reg memToReg,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite,
    output reg [2:0] ALUop,
    output reg jal,
    output reg jalr,
    output reg lui,
    output reg auipc, 
    output reg load
);

    wire [4:0] opcode = inst[6:2]; // Standard opcode field

    always @(*) begin
        // Default values
        branch    = 0;
        memRead   = 0;
        memToReg  = 0;
        memWrite  = 0;
        ALUSrc    = 0;
        regWrite  = 0;
        ALUop     = 3'b000;
        jal       = 0;
        jalr      = 0;
        lui       = 0;
        auipc     = 0;
        load =1;
        // Inside always @(*) block, before the case
        if (inst[6:0] == 7'b1110011 && inst[14:12] == 3'b000) begin
            // ebreak + ecall: disable writes and stop execution signal (optional)
            branch    = 0;
            memRead   = 0;
            memToReg  = 0;
            memWrite  = 0;
            ALUSrc    = 0;
            regWrite  = 0;
            ALUop     = 3'b000;
            jal       = 0;
            jalr      = 0;
            lui       = 0;
            auipc     = 0;
            load = 0;
            $display("EBREAK encountered"); // optional for sim
        end
        else if (inst[6:0] == 7'b0001111 && inst[14:12] == 3'b000) begin
            // pause (fence)
            branch    = 0;
            memRead   = 0;
            memToReg  = 0;
            memWrite  = 0;
            ALUSrc    = 0;
            regWrite  = 0;
            ALUop     = 3'b000;
            jal       = 0;
            jalr      = 0;
            lui       = 0;
            auipc     = 0;
            load = 0;
            $display("PAUSE encountered"); // optional
        end
        // FENCE
        else if (inst[6:0] == 7'b0001111 && inst[14:12] == 3'b000) begin
            branch    = 0;
            memRead   = 0;
            memToReg  = 0;
            memWrite  = 0;
            ALUSrc    = 0;
            regWrite  = 0;
            ALUop     = 3'b000;
            jal       = 0;
            jalr      = 0;
            lui       = 0;
            auipc     = 0;
            load = 0;
            $display("FENCE encountered");
        end
        // FENCE.TSO
        else if (inst[6:0] == 7'b0001111 && inst[14:12] == 3'b001) begin
            branch    = 0;
            memRead   = 0;
            memToReg  = 0;
            memWrite  = 0;
            ALUSrc    = 0;
            regWrite  = 0;
            ALUop     = 3'b000;
            jal       = 0;
            jalr      = 0;
            lui       = 0;
            auipc     = 0;
            load = 0;
            $display("FENCE.TSO encountered");
        end
        else begin

        case (opcode)
            5'b01100: begin // R-type
                regWrite = 1;
                ALUop    = 3'b010;
            end
            5'b00000: begin // Load
                memRead  = 1;
                memToReg = 1;
                ALUSrc   = 1;
                regWrite = 1;
                ALUop    = 3'b000;
            end
            5'b01000: begin // Store
                memWrite = 1;
                ALUSrc   = 1;
                ALUop    = 3'b000;
            end
            5'b11000: begin // Branch
                branch = 1;
                ALUop  = 3'b001;
            end
            5'b00100: begin // I-type ALU
                ALUSrc   = 1;
                regWrite = 1;
                ALUop    = 3'b011;
            end
            5'b11011: begin // JAL
                jal      = 1;
                regWrite = 1;
                ALUSrc   = 1;
                ALUop    = 3'b000;
            end
            5'b11001: begin // JALR
                jalr     = 1;
                regWrite = 1;
                ALUSrc   = 1;
                ALUop    = 3'b000;
            end
            5'b01101: begin // LUI
                lui      = 1;
                ALUSrc   = 1;
                regWrite = 1;
                ALUop    = 3'b100;
            end
            5'b00101: begin // AUIPC
                auipc    = 1;
                ALUSrc   = 1;
                regWrite = 1;
                ALUop    = 3'b000;
            end
            default: begin
                // Unrecognized opcode: safe default
                branch    = 0;
                memRead   = 0;
                memToReg  = 0;
                memWrite  = 0;
                ALUSrc    = 0;
                regWrite  = 0;
                ALUop     = 3'b000;
                jal       = 0;
                jalr      = 0;
                lui       = 0;
                auipc     = 0;
            end
        endcase
        end
    end

endmodule
