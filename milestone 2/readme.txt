Student Names
- Ebram Raafat - 900214496
- Eman Abd Elhady - 900226489

Date
- 10.4.2025

Assumptions
- The data memory is little-endian.
- The instruction memory is big-endian.

What Works
- The processor supports all specified RISC-V instructions.
- Instruction fetching and decoding processes works properly.
- The program counter functions well.
- The control unit functions well, generating all needed signals.
- The ALU also does the expected operations.
- The register file and data memory correctly handles read and write operations.

What Does Not Work
- The design was not tested on the Nexays A7100T board (yet this was optional at this stage). 

Notes
- The test cases took a sample of instructions from each type. For example, not all i-format instructions were tested one by one.