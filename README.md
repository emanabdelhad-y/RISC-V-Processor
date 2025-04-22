# RISC-V-Processor (FPGA Implementation)

<p align="center" style="display: flex; justify-content: center; align-items: center; gap: 30px;">
  <img src="https://riscv.org/wp-content/uploads/2024/08/riscv-color.svg" alt="RISC-V Logo" style="height: 80px; width: auto;"/>
  <img src="https://cdn11.bigcommerce.com/s-7gavg/images/stencil/original/image-manager/2024-identity-logothumb1-300x100.png?t=1711565133" alt="Xilinx FPGA" style="height: 50px; width: auto;"/>
</p>

<div align="center">
  
[![RISC-V ISA](https://img.shields.io/badge/RISC--V-RV32I-4051B5?logo=riscv&style=for-the-badge)](https://riscv.org)
[![FPGA Board](https://img.shields.io/badge/Nexys-A7_100T-000000?logo=xilinx&style=for-the-badge)](https://digilent.com/reference/programmable-logic/nexys-a7/start)


</div>

## Overview

This project implements a pipelined RISC-V RV32I processor on the Nexys A7 FPGA board. The processor supports all 42 base integer instructions (excluding ECALL, EBREAK, PAUSE, FENCE, and FENCE.TSO which are implemented as halt instructions) with correct hazard handling.

## Key Features

- **RV32I Instruction Set Support**: Implements all required instructions from the RISC-V specification
- **Pipelined Architecture**: 3-stage pipeline with hazard detection and handling
- **Single Memory Design**: Uses a single-port, byte-addressable memory for both instructions and data
- **Every-other-cycle issuing**: Resolves structural hazards by issuing instructions every 2 clock cycles
- **Test Coverage**: Includes comprehensive test cases covering all instructions and hazard scenarios

## Repository Structure

```
├── milestone_2/
│   ├── docs/
│   │   ├── Ebram_journal.txt
│   │   ├── Eman_journal.txt
│   │   ├── Milestone_2_Report.pdf
│   │   ├── readme.txt
│   │   └── schematic.pdf
│   ├── simulation/
│   │   └── waveforms.png
│   ├── tests/
│   │   ├── addi.hex.txt      # Hex files in .hex.txt format
│   │   ├── auipc.hex.txt
│   │   └── jal.hex.txt
│   └── verilog/
│       ├── sim_1/
│       └── sources_1/
│
├── milestone_3/                  # Milestone 3: Pipelined implementation
│   ├── docs/                     # Documentation and schematics
│   │   ├── *
│   │   └── *
│   ├── simulation/               # Simulation results
│   │   ├── *
│   │   └── testbench.v           # Pipeline testbench
│   ├── tests/                    # Test programs
│   │   ├── *
│   │   └── *
│   └── verilog/                 # Verilog source files
│       ├── *
│       └── *
│
└── README.md                    # Project overview and documentation
```

## Getting Started

### Prerequisites

- Xilinx Vivado (for FPGA synthesis and implementation)
- Nexys A7 FPGA board
- RISC-V toolchain (for compiling test programs)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/emanabdelhad-y/RISC-V-Processor.git
   ```

2. Open the project in Vivado:
   ```bash
   cd RISC-V-Processor
   vivado -source scripts/create_project.tcl
   ```

### Running Tests

1. Synthesize the design in Vivado
2. Program the FPGA
3. Load test programs into memory
4. Monitor execution through onboard LEDs or UART output

## Team Members

- [Eman Abd Elhady] (ID: 900226489)
- [Ebram Raafat] (ID: 900226489)

## Milestones

- **MS1**: Team formation and project setup (Completed)
- **MS2**: Single-cycle implementation (Completed)
- **MS3**: Pipelined implementation with full testing (April 30)

## Bonus Features Implemented

1. [Yet to be implemented]

## Known Issues

- [None found yet]

## Acknowledgments

- RISC-V International for the ISA specification

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
