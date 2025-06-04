`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 08:27:54 PM
// Design Name: 
// Module Name: decompressionUnit
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


//module decompressionUnit(input [31:0] Instruction, input MemRead, output [31:0] decompressedInst);

//always @(*) begin
//       if (MemRead) begin
//            if ( !(Instruction[1:0] == 2'b11) )
//            begin
//            decompressedInst = 
//            end
//end
//       end

//endmodule


module decompressionUnit (
    input  wire [31:0] inst_in,         // Raw instruction from memory
    output wire [31:0] inst_out,        // Decompressed 32-bit instruction
    output wire        is_compressed    // Signal: 1 if compressed
);

    wire [15:0] instr16 = inst_in[15:0];  // Lower 16 bits (may be compressed)
    assign is_compressed = (instr16[1:0] != 2'b11);  // Compressed if not 11

    reg [31:0] decompressed;

    always @(*) begin
        if (instr16[1:0] != 2'b11) begin  // Compressed instruction
            case (instr16[1:0])
                2'b00: begin  // C0 format
                    case (instr16[15:13])
                        3'b000: begin  // C.ADDI4SPN
                            decompressed = {2'b00, instr16[10:7], instr16[12:11], 
                                          instr16[5], instr16[6], 2'b00, 
                                          5'b00010, 3'b000, 2'b01, instr16[4:2], 7'b0010011};
                            // ADDI rd', x2, nzuimm[9:2]
                        end
                        3'b010: begin  // C.LW
                            decompressed = {5'b00000, instr16[5], instr16[12:10], 
                                          instr16[6], 2'b00, 2'b01, instr16[9:7], 
                                          3'b010, 2'b01, instr16[4:2], 7'b0000011};
                            // LW rd', rs1', uimm[6:2]
                        end
                        // Add more C0 instructions here
                        default: decompressed = 32'h00000013;  // NOP
                    endcase
                end
                2'b01: begin  // C1 format
                    case (instr16[15:13])
                        3'b000: begin  // C.ADDI
                            decompressed = {{7{instr16[12]}}, instr16[12], instr16[6:2],
                                           instr16[11:7], 3'b000, instr16[11:7], 7'b0010011};
                            // ADDI rd, rd, nzimm[5:0]
                        end
                        3'b010: begin  // C.LI
                            decompressed = {{7{instr16[12]}}, instr16[12], instr16[6:2],
                                           5'b00000, 3'b000, instr16[11:7], 7'b0010011};
                            // ADDI rd, x0, imm[5:0]
                        end
                        // Add more C1 instructions here
                        default: decompressed = 32'h00000013;  // NOP
                    endcase
                end
                2'b10: begin  // C2 format
                    case (instr16[15:13])
                        3'b000: begin  // C.SLLI
                            decompressed = {7'b0000000, instr16[6:2], instr16[11:7],
                                           3'b001, instr16[11:7], 7'b0010011};
                            // SLLI rd, rd, shamt[5:0]
                        end
                        3'b100: begin  // C.JR or C.MV
                            if (instr16[12] == 1'b0) begin  // C.JR
                                decompressed = {12'b000000000000, instr16[6:2],
                                               5'b00000, 3'b000, instr16[11:7], 7'b1100111};
                                // JALR x0, rs1, 0
                            end else begin  // C.MV
                                decompressed = {7'b0000000, instr16[6:2], 5'b00000,
                                               3'b000, instr16[11:7], 7'b0110011};
                                // ADD rd, x0, rs2
                            end
                        end
                        // Add more C2 instructions here
                        default: decompressed = 32'h00000013;  // NOP
                    endcase
                end
                default: decompressed = 32'h00000013;  // NOP
            endcase
        end else begin  // Regular 32-bit instruction
            decompressed = inst_in;
        end
    end

    assign inst_out = decompressed;

endmodule