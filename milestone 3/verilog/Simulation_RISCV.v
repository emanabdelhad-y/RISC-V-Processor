`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 09:50:55 AM
// Design Name: 
// Module Name: Simulation_RISCV
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


module Simulation_RISCV();
reg clk;
reg rst;
RISCV_pipeline SIM(clk,rst);

initial begin 
clk = 0; 
forever #5 clk = ~clk;
end


initial begin 
rst =1; 

#10
rst =0;

#300
$finish;
end

endmodule
