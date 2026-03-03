<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The goal of this project is to implement a bit serial multiply-accumulate (MAC) which is controlled by a Finte State Machine (FSM). It has two 4 bit inputs (A and B) and outputs a max of a 8 bit number. 
Algorithm:
    Step 1: If the LSB of B is equal to 1 add A to ACC
    Step 2: Shift A left by 1
    Step 3: Shift B right by 1
    Step 4: Repeat until all bits are proccessed

## How to test

The design is verfied using cocotb which is a python library that is used to test Verilog code. I use the random library in python to assign inputs A and B a value and perform multiplication to test it against the design. I do this test 20 times. 

To test my design, go into the test folder and run make. This will run the 20 random tests.
Step 1: cd test
Step 2: make

## External hardware

N/A
