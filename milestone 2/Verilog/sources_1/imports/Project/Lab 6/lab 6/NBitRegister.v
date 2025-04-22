`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 08:46:30 AM
// Design Name: 
// Module Name: NBitRegister
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


module NBitRegister #(parameter N = 8)(input[N-1:0] D, input clk, input rst, input load, output [N-1:0]Q);

//    always @(posedge (clk) or posedge(rst)) begin
//        if (rst == 1'b1)
//            Q <= {N{1'b0}};
//        else begin
//            if(load == 1'b1)
//               Q <= D;
//        end
//    end 
    
//endmodule

   
   
   
   
   
    wire [N-1:0] C;
    genvar i;

	// Generate for loop to instantiate N times
	generate
		for (i = 0; i < N; i = i + 1) begin
          MUX2to1 mux (D[i], Q[i], C[i], load );
          DFlipFlop dff (clk, rst, C[i], Q[i]);
		end
	endgenerate
endmodule
