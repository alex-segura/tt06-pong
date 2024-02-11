# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from encoder import Encoder
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge

PADDLE_MAX = 430

@cocotb.test()
async def test_paddle_range(dut):
  dut._log.info("Start")
  clocks_per_phase = 5
  enc0 = Encoder(dut.clk, dut.ui_in[0], dut.ui_in[1], clocks_per_phase=clocks_per_phase, noise_cycles=0)
  enc1 = Encoder(dut.clk, dut.ui_in[2], dut.ui_in[3], clocks_per_phase=clocks_per_phase, noise_cycles=0)
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1

  dut._log.info("Test")
  # increase paddle to max
  for i in range(clocks_per_phase * 2 * PADDLE_MAX):
    await enc0.update(1)
    await enc1.update(1)

  # wait for vsync
  await FallingEdge(dut.user_project.vsync)
  await ClockCycles(dut.clk, 10)
  assert dut.user_project.pong.paddle1_vpos.value.integer == PADDLE_MAX
  assert dut.user_project.pong.paddle2_vpos.value.integer == PADDLE_MAX

  # decrease paddle to min
  for i in range(clocks_per_phase * 2 * PADDLE_MAX):
    await enc0.update(-1)
    await enc1.update(-1)

  # wait for vsync
  await FallingEdge(dut.user_project.vsync)
  await ClockCycles(dut.clk, 10)
  assert dut.user_project.pong.paddle1_vpos.value.integer == 0
  assert dut.user_project.pong.paddle2_vpos.value.integer == 0
