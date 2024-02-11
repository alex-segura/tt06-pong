import cocotb
from encoder import Encoder
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge

@cocotb.test()
async def test_blank_interval(dut):
    dut._log.info("Start")
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
    # check display is off during horizontal blanking interval
    await FallingEdge(dut.uo_out[7])
    assert dut.uo_out[0] == 0
    assert dut.uo_out[4] == 0
    assert dut.uo_out[1] == 0
    assert dut.uo_out[5] == 0
    assert dut.uo_out[2] == 0
    assert dut.uo_out[6] == 0
    # check display is off during vertical blanking interval
    await FallingEdge(dut.user_project.vsync)
    assert dut.uo_out[0] == 0
    assert dut.uo_out[4] == 0
    assert dut.uo_out[1] == 0
    assert dut.uo_out[5] == 0
    assert dut.uo_out[2] == 0
    assert dut.uo_out[6] == 0
