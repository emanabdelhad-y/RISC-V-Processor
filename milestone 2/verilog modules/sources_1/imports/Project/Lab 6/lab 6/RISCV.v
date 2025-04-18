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

module RISCV(input clk, rst);
wire [31:0] PCInput, PCOutput, AddressAdderOPut;
wire [31:0] inst;
wire  branch, memRead, memToReg, memWrite, ALUSrc, regWrite, cf, zf, vf, sf;
wire [2:0] ALUop;
wire [3:0] ALUSel;
wire [31:0] readData1, readData2;
wire [31:0] gen, shiftedGen;
wire [31:0] shiftSum;
wire [31:0] ALUInput, ALUOutput;
wire [31:0] readData, RegWriteData, muxWriteData;
wire d;
wire jump;
wire auipc;
wire [31:0] mux_to_mux;
wire [1:0] pcSelect;
wire pcLoad;

//0 > B
NBitRegister #(32) PC     ( PCInput, clk, rst, pcLoad, PCOutput);
nBitRCA PCAdder     ( PCOutput, 32'd4, AddressAdderOPut, d);
InstMem instMem     ( PCOutput[7:2], inst);
controlUnit CU      ( inst, branch, memRead, memToReg, memWrite, ALUSrc, regWrite,  ALUop, auipc, jump , pcSelect, pcLoad);
RegFile regFile     ( regWrite, clk, rst, inst[19:15], inst[24:20], inst[11:7], muxWriteData, readData1, readData2);

MUX4By1NBit RegisterDataMux (gen, AddressAdderOPut,  shiftSum, RegWriteData, {auipc, jump}, muxWriteData);

//ImmGen immGem       ( inst, gen);
rv32_ImmGen immGem(inst, gen); 
NBitShiftLeft sl   ( gen,  shiftedGen);
reg  [31:0] input_to_AddresAdder;
always @ (*) begin

    if ({auipc,jump} == 2'b10) 
        input_to_AddresAdder = gen;
    else 
        input_to_AddresAdder = shiftedGen; 
end
nBitRCA AddresAdder ( input_to_AddresAdder, PCOutput, shiftSum, d);

wire resBranch;
BranchingUnit BU(cf, zf, vf, sf, branch,inst [14:12], resBranch);
nBitMUX2to1 #(32) shiftSumMux  (shiftSum, AddressAdderOPut ,  resBranch|jump,  mux_to_mux);


MUX4By1NBit PCFinalMux (AddressAdderOPut, mux_to_mux,  ALUOutput, 32'd0, pcSelect, PCInput);


ALUControlUnit ALUCU(inst ,ALUop, ALUSel);

nBitMUX2to1 #(32) DownMux2to1 ( gen, readData2 ,  ALUSrc,  ALUInput);
//nBitALU ALU         ( readData1, ALUInput, ALUSel ,  ALUOutput , zf);
DataMem dataMem     ( clk, memRead, memWrite, ALUOutput[7:2],  readData2, readData, inst[14:12]);
nBitMUX2to1 #(32) RightMux2to1( readData,  ALUOutput,  memToReg,  RegWriteData);

reg [4:0] input_to_shifter;

always @ (*) begin

    if (inst[5] == 1) 
        input_to_shifter = readData2[4:0];
    else if (inst[5] == 0) 
        input_to_shifter = inst[24:20]; 
end

prv32_ALU alu (.a(readData1),.b(ALUInput),.shamt(input_to_shifter), .r(ALUOutput),.cf(cf),.zf(zf),.vf(vf),.sf(sf),.alufn(ALUSel));
endmodule
