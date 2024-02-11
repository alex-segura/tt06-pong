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
    await ClockCycles(dut.clk, 800*525)
    # check display is off during horizontal blanking interval
    await ClockCycles(dut.clk, 639+18)
    assert dut.uo_out[0].value == 0
    assert dut.uo_out[4].value == 0
    assert dut.uo_out[1].value == 0
    assert dut.uo_out[5].value == 0
    assert dut.uo_out[2].value == 0
    assert dut.uo_out[6].value == 0
    # check display is off during vertical blanking interval
    await ClockCycles(dut.clk, 799*479+10)
    assert dut.uo_out[0].value == 0
    assert dut.uo_out[4].value == 0
    assert dut.uo_out[1].value == 0
    assert dut.uo_out[5].value == 0
    assert dut.uo_out[2].value == 0
    assert dut.uo_out[6].value == 0
