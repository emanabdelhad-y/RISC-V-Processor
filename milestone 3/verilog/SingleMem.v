`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2025 04:09:31 PM
// Design Name: 
// Module Name: SingleMem
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


module SingleMem(

    input clk,
    input MemRead,
    input MemWrite,
    input [2:0] func3,
    input [6:0] addr,
    input [31:0] dataIn,
    output reg [31:0] Instruction
);

    reg [7:0] Mem [0:4095];
    reg [31:0] InstMem [0:31];

    initial begin
        //$readMemh("C:/Users/emanessam26/Downloads/FinalProj/SingleMemTest/addi.hex.txt", InstMem);
        //$readMemh("C:/Users/emanessam26/Downloads/FinalProj/SingleMemTest/auipc.hex.txt", InstMem);
        //$readmemh("C:/Users/emanessam26/Downloads/FinalProj/SingleMemTest/sformat.hex.txt", InstMem);
        
        //$readMemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/addi.hex.txt", InstMem);
        //$readMemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/auipc.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/load.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/store.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/lui.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/branch.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/jal.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/jalr.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/ebreak.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/ecall.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/fence.hex.txt", InstMem);
        $readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/srl.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/sformat.hex.txt", InstMem);
        //$readmemh("C:/Users/emana/OneDrive/Desktop/Final proj/Final proj 4 5/FinalProj/SingleMemTest/caddi.hex.txt", InstMem);
    end

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            {Mem[(i * 4) + 3], Mem[(i * 4) + 2], Mem[(i * 4) + 1], Mem[i * 4]} = InstMem[i];
    end

    initial begin
        {Mem[131], Mem[130], Mem[129], Mem[128]} = 32'd17;
        {Mem[135], Mem[134], Mem[133], Mem[132]} = 32'd9;
        {Mem[139], Mem[138], Mem[137], Mem[136]} = 32'd25;
        {Mem[143], Mem[142], Mem[141], Mem[140]} = 32'd34;
        //4 Mem[144]
        //5 Mem[148]
        //6 > Mem[152] >152 = 128 + addr > addr= 24
    end

    always @(posedge clk) begin
        $display("In memory");

        if (MemWrite == 1'b1) begin
            $display("In memWrite conditino");

            case (func3)
                3'b000: begin
                    Mem[addr + 128] = dataIn[7:0];
                    $display("Store Byte: Address = %0d, Data = %0h", addr + 128, dataIn[7:0]);
                end
                3'b001: begin
                    {Mem[addr + 129], Mem[addr + 128]} = dataIn[15:0];
                    $display("Store Halfword: Address = %0d, Data = %0h", addr + 128, dataIn[15:0]);
                end
                3'b010: begin
                    {Mem[addr + 131], Mem[addr + 130], Mem[addr + 129], Mem[addr + 128]} = dataIn;
                    $display("Store Word: Address = %0d, Data = %0h", addr + 128, dataIn);
                end
                default: $display("Unknown func3 in store: %b", func3);
            endcase
        end
    end


    always @(*) begin
        if (~clk) begin
            if (MemRead) begin
                case (func3)
                    3'd0: Instruction <= {{24{Mem[addr + 128][7]}}, Mem[addr + 128]}; // Sign-extend byte
                    3'd1: Instruction <= {{16{Mem[addr + 1 + 128][7]}}, Mem[addr+ 1 + 128], Mem[addr+ 128]};
                    3'd2: Instruction <= {Mem[addr + 3 + 128], Mem[addr + 2 + 128], Mem[addr+ 1 + 128], Mem[addr+ 128]};
                    3'd4: Instruction <= {24'd0, Mem[addr + 128]};
                    3'd5: Instruction <= {16'd0, Mem[addr + 1 + 128], Mem[addr + 128]};
                    default: Instruction <= 0;
                endcase
            end
        end else begin
            Instruction = {Mem[addr + 3], Mem[addr + 2], Mem[addr + 1], Mem[addr]};
        end
    end

endmodule

