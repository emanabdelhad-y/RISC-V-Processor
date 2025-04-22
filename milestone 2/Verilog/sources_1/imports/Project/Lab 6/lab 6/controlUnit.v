`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 10:45:32 AM
// Design Name: 
// Module Name: controlUnit
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


module controlUnit
                   (input [31:0]inst, 
                    output reg branch, 
                    memRead, 
                    memToReg, 
                    memWrite, 
                    ALUSrc, 
                    regWrite, 
                    output reg [2:0] ALUop, 
                    output reg auipc, jump,
                    output reg [1:0] pcs,
                    output reg pcLoad
                    );

always @ (*)begin
    if (inst[6:2] == 5'b01100) //R
    begin 
    pcs = 2'b00;
    branch = 0;
    memRead =0;
    memToReg =0;
    ALUop = 3'b010;
    memWrite =0;
    ALUSrc = 0;
    regWrite =1;
    auipc =1;
    jump =1;
    pcLoad=1;
    end
    else if (inst[6:2] == 5'b00000)    //load
    begin 
    pcs = 2'b00;
    branch = 0;
    memRead = 1;
    memToReg = 1;
    ALUop = 3'b000;
    memWrite = 0;
    ALUSrc = 1;
    regWrite = 1;
    auipc =1;
    jump =1;
        pcLoad=1;

    end
    else if (inst[6:2] == 5'b01000)    //store
    begin 
    pcs = 2'b00;
    branch = 0;
    memRead = 0;
    memToReg = 1'bx;
    ALUop = 3'b000;
    memWrite = 1;
    ALUSrc = 1;
    regWrite = 0;
        auipc =1;
    jump =1;
        pcLoad=1;

    end
    else if (inst[6:2] == 5'b11000)  //branch
      begin 
    pcs = 2'b01;
    branch = 1;
    memRead = 0;
    memToReg = 1'bx;
    ALUop = 3'b001;
    memWrite = 1'b0;
    ALUSrc = 1'b0;
    regWrite = 1'b0;
    auipc =1;
    jump =1;
        pcLoad=1;

    end
    else if (inst[6:2] == 5'b00100 ) //I
    begin
    pcs = 2'b00;
    branch = 0;
    memRead =0;
    memToReg =0;
    ALUop = 3'b011;
    memWrite = 1'b0;
    ALUSrc = 1'b1;
    regWrite = 1'b1; 
    auipc =1;
    jump =1;
        pcLoad=1;

    end
    else if (inst[6:2] == 5'b01101) //lui
    begin 
        pcs = 2'b00;
        branch = 0;
        memRead =0;
        memToReg =0;
        ALUop = 3'b100;
        memWrite = 1'b0;
        ALUSrc = 1'b1;
        regWrite = 1'b1; 
        auipc =0;
        jump =0;
        pcLoad=1;

    end
    else if (inst[6:2] == 5'b00101) //auipc
    begin
        pcs = 2'b00;
        branch = 0;
        memRead =0;
        memToReg =0;
        ALUop = 3'b000;
        memWrite = 1'b0;
        ALUSrc = 1'b1;
        regWrite = 1'b1; 
        auipc =1;
        jump =0;
            pcLoad=1;

    end
    else if (inst[6:2] == 5'b11011) //jal
    begin
        pcs = 2'b01;
        branch = 0;
        memRead =0;
        memToReg =0;
        ALUop = 3'b000;
        memWrite = 1'b0;
        ALUSrc = 1'b1;
        regWrite = 1'b1; 
        auipc = 0;
        jump = 1;
            pcLoad=1;

    end
    else if (inst[6:2] == 5'b11001) //jalr
    begin
        pcs = 2'b10;
        branch = 0;
        memRead =0;
        memToReg =0;
        ALUop = 3'b000;
        memWrite = 1'b0;
        ALUSrc = 1'b1;
        regWrite = 1'b1; 
        auipc = 0;
        jump = 1;
            pcLoad=1;

    end
    else if (inst[6:2] == 5'b00011) //fence
    begin
        pcs = 2'b11;
        branch = 0;
        memRead =0;
        memToReg =0;
        ALUop = 3'b000;
        memWrite = 1'b0;
        ALUSrc = 1'b0;
        regWrite = 1'b0; 
        auipc = 0;
        jump = 0;
            pcLoad=0;

    end
    else if (inst[6:2] == 5'b11100 && inst[20] == 1'b0) //ecall
    begin
        pcs = 2'b11;
        branch = 0;
        memRead = 0;
        memToReg = 0;
        ALUop = 3'b000;
        memWrite = 1'b0;
        ALUSrc = 1'b0;
        regWrite = 1'b0; 
        auipc = 0;
        jump = 0;
        pcLoad=0;

    end
    else if (inst[6:2] == 5'b11100 && inst[20] == 1'b1) //ebreak
    begin
        pcs = 2'b00;
        branch = 0;
        memRead = 0;
        memToReg = 0;
        ALUop = 3'b000;
        memWrite = 1'b0;
        ALUSrc = 1'b0;
        regWrite = 1'b0; 
        auipc = 0;
        jump = 0;
            pcLoad=0;

    end
    else begin
        pcs = 2'b00;
        branch = 0;
        memRead = 0;
        memToReg = 0;
        ALUop = 3'b000;
        memWrite = 1'b0;
        ALUSrc = 1'b0;
        regWrite = 1'b0; 
        auipc = 0;
        jump = 0;
        pcLoad=0;

    end
    //fence.tso
    //pasue

end
endmodule
