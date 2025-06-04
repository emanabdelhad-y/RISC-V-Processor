==============================================
Project: femtoRV32 - RISC-V FPGA Implementation
Course: CSCE 3301
Semester: Spring 2025
Milestone: 3
==============================================
Student Names:
- Eman Abd ElHady
- Ebram Thabet
==============================================
Team Name: 
Overclock
==============================================
Release Notes
==============================================
1. Overview: 
The project is implementing the femtoRV32, which is a simplified processor of RISC-V. The processor supports the full set of 42 instructions in RC32I. The design is 
a pipeline that handles hazards. 

2.Issues (All solved): 
- Not supporting other operations like mul, div. 
- Not having branch predictor.

3. Assumptions: 
- The memory is byte addressable. 
- ECALL, EBREAK, and FENCE are treating as instructions that stops the pipeline.
- Single memory is used for data and instructions.  
- The pipeline is 3-stage pipeline.

4. What works:
- Fully working pipeline of the 42 user-level instructions. 
- Pipelining the handles RAW dependencies. 
- Functioning simulation that tests properly the instruction. 
- Reading the instruction from outside the vivado program in separate file. 
- A program generator of instructions implemented by python. 
- Decomposition unit to handle compressed instructions

5. References: 
- RISC-V manual (https://riscv.org/specifications/ratified/)