`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 09:09:21 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem(input clk, input MemRead, input MemWrite,input [5:0] addr, input [31:0] data_in, output reg [31:0] data_out, input [2:0] func3);
    reg [31:0] mem [0:63];
    
    
        always @ (posedge clk) begin
        if(MemWrite) begin
            case (func3)
                3'b010: // store w
                {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} = data_in; // Store 4 bytes   
                3'b001: // store half w
                {mem[addr+1], mem[addr]} = data_in[15:0]; // Store lower 2 
                3'b000: // store byte
                mem[addr] = data_in[7:0]; // Store the byte
                default: 
                mem[addr] = mem[addr];
            endcase
        end
    end
    always @ (*) begin
        if(MemRead) begin
            case (func3)
                3'b001: // load half w
                data_out = $signed({mem[addr+1], mem[addr]});  
                3'b000: // load byte
                data_out = $signed({mem[addr]});    
                3'b101: // load half w unsigned
                data_out = {mem[addr+1], mem[addr]};
                3'b100: // load byte unsigned
                data_out = mem[addr];  
                3'b010: // load w
                data_out = $signed({mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}); 
                default: 
                data_out = 32'bx;
            endcase
        end else begin
            data_out = 32'bx;
        end
    end

    
    
    
    
    
    initial begin
        mem[0]=32'd17;
        mem[1]=32'd9;
        mem[2]=32'd25;  
        end
    
endmodule
