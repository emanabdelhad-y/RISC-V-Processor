module InstMem(input [5:0] addr, output [31:0] data_out);
    reg [31:0] mem [0:1023]; // Now storing 32-bit words
    integer i;

    initial begin
//        $readmemh("C:/Users/emanessam26/tests/addi.hex.txt", mem);
//        $readmemh("C:/Users/emanessam26/tests/lui.hex.txt", mem);
//        $readmemh("C:/Users/emanessam26/tests/jalr.hex.txt", mem);
//        $readmemh("C:/Users/emanessam26/tests/jal.hex.txt", mem);

//        $readmemh("C:/Users/emanessam26/tests/sformat.hex.txt", mem);
          
          $readmemh("C:/Users/emanessam26/tests/auipc.hex.txt", mem);

//        $readmemh("C:/Users/emanessam26/tests/branch.hex.txt", mem);
//        $readmemh("C:/Users/emanessam26/tests/ebreak.hex.txt", mem);
//        $readmemh("C:/Users/emanessam26/tests/srl.hex.txt", mem);

        // Debugging: Print first few memory locations
        $display("First few memory locations:");
        for (i = 0; i < 5; i = i + 1) begin
            $display("mem[%0d] = %h", i, mem[i]);
        end
    end

    assign data_out = mem[addr]; // Directly output the 32-bit word
endmodule