`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 10:10:14 AM
// Design Name: 
// Module Name: RISCV
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

//output [15:0] LEDs, input [1:0] ledSel, input [3:0] ssdSel, output [12:0] ssd, input SSdclk);

//, input [3:0] ssdSel, input [1:0]ledSel, output reg [12:0] SSD_out ,output reg [15:0] LEDs

module  RISCV_pipeline (input clk, rst);
reg [31:0] PCInput;
wire [31:0] PCOutput, AddressAdderOPut;
wire [31:0] inst;
wire  branch, memRead, memToReg, memWrite, ALUSrc, regWrite;
wire [2:0] ALUop;
wire [3:0] ALUSel;
wire [31:0] readData1, readData2;
wire [31:0] gen, shiftedGen;
wire [31:0] shiftSum;
reg [31:0]  muxWriteData;
wire [31:0] ALUInput, ALUOutput;
wire [31:0] readData, RegWriteData;
wire d;
wire [1:0]forwardA, forwardB;
wire PCSrc;
wire [31:0] newInst;
wire [31:0] inputALU_B;
wire [31:0] inputALU_A;
wire [12:0] output_hazard_mux;
wire [8:0] ExMemMUXControlGeneratorOut;
wire sclk;
wire jal, jalr, lui, auipc;
wire [31:0] mux_to_mux;
wire [1:0] pcSelect;
wire pcLoad;
wire resBranch;
wire [6:0] outputMEM_MUX;
//check this
wire [4:0]  shamt; //what is this? should be input
wire cf, Z, vf, sf;
assign PCSrc = resBranch || EX_MEM_Ctrl[8] || EX_MEM_Ctrl[7];

wire [31:0] newPC;
assign newPC = PCOutput + 32'd4;

wire load;

NBitRegister #(32) PC     ( PCInput, sclk, rst, load , PCOutput);
controlUnit CU      ( IF_ID_Inst, branch, memRead, memToReg, memWrite, ALUSrc, regWrite, ALUop, jal, jalr, lui, auipc, load);
RegFile regFile     ( MEM_WB_Ctrl[0], ~sclk, rst, IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd, muxWriteData, readData1, readData2);

DFF slowerClock (clk, sclk );

//changed the immGen used
rv32_ImmGen ImmGen       ( IF_ID_Inst, gen);
NBitShiftLeft sl    ( ID_EX_Imm, shiftedGen);

//nBitRCA PCAdder     ( PCOutput, 32'd4, AddressAdderOPut, d);
nBitRCA AddresAdder1 ( shiftedGen, ID_EX_PC , shiftSum, d);

reg  [31:0] input_to_AddresAdder;
always @ (*) begin

    if ({auipc, jal | jalr} == 2'b10) 
        input_to_AddresAdder = gen;
    else 
        input_to_AddresAdder = shiftedGen; 
end
//nBitRCA AddresAdder ( input_to_AddresAdder, PCOutput, shiftSum, d);

//MUX4By1NBit RegisterDataMux (gen, AddressAdderOPut,  shiftSum, RegWriteData, MEM_WB_Ctrl[0], muxWriteData);

// mem wb ctrl >>  jal, jalr, lui, auipc ,memToReg, regWrite,
//always @(*) begin
//    if (MEM_WB_Ctrl == 6'bxxxx11) // memToReg
//        muxWriteData = MEM_WB_Mem_out;
//    else if (MEM_WB_Ctrl == 6'b1xxxx1 || MEM_WB_Ctrl == 6'bx1xxx1) // jal or jalr
//        muxWriteData = MEM_WB_PC + 32'd4;
//    else if (MEM_WB_Ctrl == 6'bxxx1xx1) // lui
//        muxWriteData = MEM_WB_Imm;
//    else if (MEM_WB_Ctrl == 6'bxxx1x1) // auipc
//        muxWriteData = MEM_WB_PC + MEM_WB_Imm;
//    else
//        muxWriteData = MEM_WB_ALU_out;
//end


always @(*) begin
    // memToReg: Check if bits [1:0] = 2'b11 (assuming bit 0 is memToReg and bit 1 is another control signal)
    if (MEM_WB_Ctrl[0] && MEM_WB_Ctrl[1]) 
        muxWriteData = MEM_WB_Mem_out;

    // jal: Check if bit 5=1 and bit 0=1
    else if ((MEM_WB_Ctrl[5] && MEM_WB_Ctrl[0]) || 
             (MEM_WB_Ctrl[4] && MEM_WB_Ctrl[0]))  // jalr: bit 4=1 and bit 0=1
        muxWriteData = MEM_WB_PC + 32'd4;

    // lui: Check if bit 2=1 and bit 0=1
    else if (MEM_WB_Ctrl[2] && MEM_WB_Ctrl[0])
        muxWriteData = MEM_WB_Imm;

    // auipc: Check if bit 3=1 and bit 0=1
    else if (MEM_WB_Ctrl[3] && MEM_WB_Ctrl[0])
        muxWriteData = MEM_WB_PC + MEM_WB_Imm;

    // Default: ALU result
    else
        muxWriteData = MEM_WB_ALU_out;
end



//MUX For Branch
always @(*) begin
    if (rst) begin
        PCInput <= 32'd0;
    end else if (!((EX_MEM_Inst[6:0] == 7'b1110011))) begin
        if (resBranch || EX_MEM_Ctrl[8])
            PCInput <= EX_MEM_BranchAddOut;
        else if (EX_MEM_Ctrl[7])
            PCInput <= EX_MEM_ALU_out;
        else
            PCInput <= newPC;
    end
end

//MUX4By1NBit PCFinalMux (AddressAdderOPut, mux_to_mux,  EX_MEM_ALU_out, 32'd0, pcSelect, PCInput);
nBitMUX2to1 #(32) branchingMUX  (32'b00000000000000000000000000110011, inst, PCSrc, newInst);
//nBitMUX2to1 #(32) TopMux2to1  ( EX_MEM_BranchAddOut ,  AddressAdderOPut,  (EX_MEM_Ctrl[2] & EX_MEM_Zero),  PCInput);
nBitMUX2to1 #(32) DownMux2to1 ( ID_EX_Imm, inputALU_B , ID_EX_Ctrl[3],  ALUInput);
nBitMUX2to1 #(32) RightMux2to1(  MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Ctrl[1],  RegWriteData);
//nBitMUX2to1 #(13) hazard_detection_mux (13'b0000000000000, {  jal, jalr, lui, auipc ,memToReg, regWrite, branch, memWrite, memRead, ALUSrc, ALUop},  PCSrc, output_hazard_mux ); //CUPicked > output_hazard_mux
nBitMUX2to1 #(9) ExMemMUXControlGenerator ( 9'b000000000, ID_EX_Ctrl[12:4], PCSrc, ExMemMUXControlGeneratorOut ); //Muxed > ExMemMUXControlGeneratorOut

nBitMUX2to1 #(7) memoryMUX (EX_MEM_IMM[6:0], PCOutput[6:0], ~sclk , outputMEM_MUX);

MUX4By1NBit muxForwardA (ID_EX_RegR1, RegWriteData, EX_MEM_ALU_out, 0, forwardA, inputALU_A); 
MUX4By1NBit muxForwardB (ID_EX_RegR2, RegWriteData, EX_MEM_ALU_out, 0, forwardB, inputALU_B); 

ALUControlUnit ALUCU (ID_EX_Func[3:0] , ID_EX_Ctrl[2:0], ALUSel );
//ALUControlUnit ALUCU (ID_EX_Func[3], ID_EX_Func[2:0] ,ID_EX_Ctrl[1:0], ALUSel);

//one mem is needed
//InstMem instMem     ( PCOutput[7:2], inst);
//DataMem dataMem     (sclk, EX_MEM_Ctrl[0], EX_MEM_Ctrl[1], EX_MEM_ALU_out[7:2],  EX_MEM_RegR2, readData); //EX_MEM_ALU_out[7:2]

//SingleMem Mem (sclk, EX_MEM_Ctrl[0], EX_MEM_Ctrl[1], EX_MEM_FUNC, outputMEM_MUX, EX_MEM_RegR2, inst);
SingleMem Mem (sclk, EX_MEM_Ctrl[0], EX_MEM_Ctrl[1], EX_MEM_FUNC, outputMEM_MUX, EX_MEM_RegR2, inst);

//wire [31:0] raw_inst;
wire [31:0] final_inst;
wire is_compressed;
//SingleMem Mem (
//    .clk(sclk),
//    .MemRead(EX_MEM_Ctrl[0]),
//    .MemWrite(EX_MEM_Ctrl[1]),
//    .funct3(EX_MEM_FUNC),
//    .address(outputMEM_MUX),
//    .writeData(EX_MEM_RegR2),
//    .readData(raw_inst)
//);
decompressionUnit decompress_unit (
    .inst_in(inst),
    .inst_out(final_inst),
    .is_compressed(is_compressed)
);


forwardingUnit FU (ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Ctrl[3], MEM_WB_Ctrl[0], forwardA, forwardB);
BranchingUnit BU (cf, Z, vf, sf, branch, EX_MEM_FUNC, resBranch);


reg [4:0] input_to_shifter;

always @ (*) begin

    if (inst[5] == 1) 
        input_to_shifter = readData2[4:0];
    else if (inst[5] == 0) 
        input_to_shifter = inst[24:20]; 
end

prv32_ALU alu (.a(inputALU_A),.b(ALUInput),.shamt(input_to_shifter), .r(ALUOutput),.cf(cf),.zf(Z),.vf(vf),.sf(sf),.alufn(ALUSel));
///////////////////////////////////////////////////////////////////////////////

//IF ID - DONE
wire [31:0] IF_ID_PC, IF_ID_Inst;
NBitRegister #(64) IF_ID ({PCOutput , final_inst}, ~sclk, rst, 1, {IF_ID_PC,IF_ID_Inst} );

//ID EX - DONE
wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
wire [12:0] ID_EX_Ctrl;
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd; 
wire [31:0] ID_EX_Inst;
NBitRegister #(192) ID_EX (
{{jal, jalr, lui, auipc ,memToReg, regWrite, branch, memWrite, memRead, ALUSrc, ALUop}, IF_ID_PC, readData1, readData2, gen, {IF_ID_Inst[30], IF_ID_Inst[14:12]},IF_ID_Inst[19:15], IF_ID_Inst [24:20], IF_ID_Inst[11:7], IF_ID_Inst}
,sclk, rst,1'b1,
{ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_Inst} );

// EX MEM - DONE
wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2; 
wire [8:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire EX_MEM_CARRY;
wire EX_MEM_Zero;
wire [2:0] EX_MEM_FUNC;
wire [31:0] Imm_PC;
wire [31:0] EX_MEM_Inst, EX_MEM_IMM, EX_MEM_PC;
//assign Imm_PC = ID_EX_PC+ shiftSum;

NBitRegister #(211) EX_MEM (
{ID_EX_Inst, ID_EX_Imm, ID_EX_PC, shiftSum, ExMemMUXControlGeneratorOut, cf, Z ,ID_EX_Func[2:0], ALUOutput, inputALU_B , ID_EX_Rd}
,~sclk, rst, 1'b1, {EX_MEM_Inst,  EX_MEM_IMM, EX_MEM_PC, EX_MEM_BranchAddOut, EX_MEM_Ctrl, EX_MEM_CARRY, EX_MEM_Zero, EX_MEM_FUNC,
EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd} );

//MEM WB - DONE
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
wire [5:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd;
wire [31:0] MEM_WB_Imm_PC, MEM_WB_Imm, MEM_WB_PC;
NBitRegister #(171) MEM_WB (
{EX_MEM_BranchAddOut, EX_MEM_IMM, EX_MEM_PC,  EX_MEM_Ctrl[8:3], inst, EX_MEM_ALU_out, EX_MEM_Rd},
sclk, rst, 1'b1
,{MEM_WB_Imm_PC, MEM_WB_Imm, MEM_WB_PC, MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd} );

///////////////////////////////////////////////////////////////////////////////
//8-5, 2, 0
//aluop
// {  jal, jalr, lui, auipc ,memToReg, regWrite, branch, memWrite, memRead, ALUSrc, ALUop}
 
// ex mem ctrl >>  jal, jalr, lui, auipc ,memToReg, regWrite, branch, memWrite, memRead
// mem wb ctrl >>  jal, jalr, lui, auipc ,memToReg, regWrite,



// all modules instantiations
// LED and SSD outputs case statements


//always @(*) begin
//if (ledSel == 2'b00)
//    LEDs = inst[15:0];
//else if (ledSel == 2'b01)
//    LEDs = inst [31:16];
//else if (ledSel == 2'b10)
//    LEDs = {2'b00, ALUop, ALUSel, Z, branch&Z};
//else
//    LEDs = 16'b0000000000000000;
//end


//always @(*) begin
//   case (ssdSel)
//        4'b0000: SSD_out = PCOutput;
//        4'b0001: SSD_out = PCOutput + 32'd4;
//        4'b0010: SSD_out = AddressAdderOPut;
//        4'b0011: SSD_out = PCInput;
//        4'b0100: SSD_out = readData1;
//        4'b0101: SSD_out = readData2;
//        4'b0110: SSD_out = RegWriteData;
//        4'b0111: SSD_out = gen;
//        4'b1000: SSD_out = shiftedGen; //
//        4'b1001: SSD_out = ALUInput;
//        4'b1010: SSD_out = ALUOutput;
//        4'b1011: SSD_out = readData;
//        default: SSD_out = 0;
//   endcase
//end



endmodule