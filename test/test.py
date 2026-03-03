# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import random

@cocotb.test()
async def test_project_random_mult(dut):

    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # Run multiple random tests
    for _ in range(20):
        A = random.randint(0, 15)
        B = random.randint(0, 15)

        dut._log.info(f"Testing A={A}, B={B}")

        dut.ui_in.value = (B << 4) | A

        # Pulse start
        dut.uio_in.value = 1
        await ClockCycles(dut.clk, 1)
        dut.uio_in.value = 0

        # Wait for done
        timeout = 20
        cycles = 0
        while (dut.uio_out.value.integer & 0x1 == 0) and cycles < timeout:
            await ClockCycles(dut.clk, 1)
            cycles += 1

        assert cycles < timeout, f"Timeout for A={A}, B={B}"

        result = dut.uo_out.value.integer
        expected = A * B
        dut._log.info(f"result = {expected}")
        assert result == expected, \
            f"FAIL A={A}, B={B}: got {result}, expected {expected}"

        # Small gap between tests
        await ClockCycles(dut.clk, 2)