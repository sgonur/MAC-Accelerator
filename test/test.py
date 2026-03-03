# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project_mult(dut):
    """Test simple multiplication using the MAC+FSM design"""

    # Start clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Initialize signals
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # Test 3 * 5
    A = 3
    B = 5
    dut.ui_in.value = (B << 4) | A  # upper 4 bits = B, lower 4 bits = A

    # start_bit = uio_in[0]
    dut.uio_in.value = 1
    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0

    # Wait for done_bit = uio_out[0], with timeout
    timeout = 20
    cycles = 0
    while (dut.uio_out.value.integer & 0x1 == 0) and cycles < timeout:
        await ClockCycles(dut.clk, 1)
        cycles += 1

    assert cycles < timeout, "FSM did not reach DONE within timeout"

    result = dut.uo_out.value.integer
    expected = A * B
    dut._log.info(f"{A} * {B} = {result}")
    assert result == expected, f"Expected {expected}, got {result}"