# Pipelined-CPU
> A Simple Implementation of a Pipelined CPU

This is a 5-Stage-Pipelined CPU which supports the following RISC-V instructions:

### R-Type Instructions

- `and`
- `xor`
- `sll`
- `add`
- `sub`

### I-Type Instructions

- `mul`
- `addi`
- `srai`
- `lw`

### S-Type Instructions

- `sw`

### SB-Type Instructions

- `beq`

### Futher Information

This pipelined CPU also supports the following features:

- Branch prediction strategy is "always not taken"
- Forwarding unit to solve the data hazard caused by arithmetic operations
- Hazard detection unit that detects the load-use hazard and stall the pipeline
- Hazard detection unit that detects the control hazard and flush the pipeline

