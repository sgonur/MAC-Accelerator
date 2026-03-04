## How it works

This project implements a **bit-serial Multiply–Accumulate (MAC) unit** controlled by a **Finite State Machine (FSM)**.

The design accepts two **4-bit unsigned operands** and produces an **8-bit accumulated result**. To minimize hardware area, the multiplication is performed serially, processing **one bit of the multiplier per cycle**, and reusing a single adder datapath across cycles.

### Algorithm

1. Check the least significant bit of **B**  
   - If `B[0] == 1`, add **A** to the accumulator (**ACC**)
2. Shift **A** left by one bit
3. Shift **B** right by one bit
4. Repeat until all bits of **B** have been processed

## How to test

The design is verfied using cocotb which is a python library that is used to test Verilog code. I use the random library in python to assign inputs A and B a value and perform multiplication to test it against the design. I do this test 20 times. 

To run the RTL simulation:

```bash
cd test
make
```

## External hardware
N/A

## Use of GenAI Tools
I used GenAI to help me get the idea for the project and also help me with the algorithm. GenAI also helped with designing the fsm and debugging a bit of the code. All AI suggestions were checked by me before usiong them.
