# RISC-V Single Cycle Processor

This Repo is my final project for Computer Architecture that describe a Single Cycle processor running the RV32I implementation written in __Verilog__.



## RISC-V reference

- Textbook: `Digital Design and Computer Architecture: RISC-V Edition by Sarah L. Harris and David Harris` 
- [RISC-V Reference Manual](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf).
  

## FPGA Board
This project will implement on the __Altera Board__.


## What's Next?
This project serves as the foundation for a complete, FPGA-based embedded systems with RISC-V SoC, Planned features include:

- Extending the core to support a 5-stage pipelined.
- Designing an FPGA-optimized microarchitecture.
- Adding support for a FreeRTOS-compatible interrupt system.
- Connecting components through standard bus interfaces such as AXI and system peripheral buses.
- Developing a UVM-verification suites to ensure functionality and correctness.

The full RISC-V SoC project will be released publicly during the summer of this year.
