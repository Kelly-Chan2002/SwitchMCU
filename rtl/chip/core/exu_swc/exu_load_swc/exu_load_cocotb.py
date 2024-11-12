import cocotb
from cocotb.triggers import Timer, RisingEdge
import random

async def generate_clock(dut):
    """Generate clock pulses."""
    for cycle in range(30):
        dut.hclk.value = 0
        await Timer(1, units="ns")
        dut.hclk.value = 1
        await Timer(1, units="ns")

async def start_cycle_cnt(dut):
    """Generate the cycle count"""
    dut.cycle_cnt.value = 1
    for cycle in range(15):
        await RisingEdge(dut.hclk)
        if(int(str(dut.cycle_cnt.value), 2) == 4):
            dut.cycle_cnt.value = 1
        else:
            dut.cycle_cnt.value = int(str(dut.cycle_cnt.value),2) + 1
  
def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val   

def load_model(cmd, rd, data, imm):
    """Model of the functionality of the load module"""
    load_rd = rd
    load_addr = data
    load_offset = twos_comp(imm, 12)
    load_sext = ((cmd == "lb") | (cmd == "lh") | (cmd == "lw"))
    load_size = ((cmd == "lb") | (cmd == "lbu")) * 1 + ((cmd == "lh") | (cmd == "lhu"))*2 + (cmd == "lw")*3
    load_en = 1
    return load_rd, load_addr, load_offset, load_sext, load_size, load_en
    
async def report_data(dut, actual_rd, actual_addr, actual_offset, actual_sext, actual_size, actual_en, rd, addr, offset, sext, size, en):
    dut._log.info("load_rd is %s when it should be %s", actual_rd, rd)
    dut._log.info("load_addr is %s when it should be %s", actual_addr, addr)
    dut._log.info("load_offset is %s when it should be %s", actual_offset, offset)
    dut._log.info("load_sext is %s when it should be %s", actual_sext, sext)
    dut._log.info("load_size is %s when it should be %s", actual_size, size)
    dut._log.info("load_en is %s when it should be %s", actual_en, en)
    assert actual_rd == rd, f"Load result for rd is incorrect: {actual_rd} != {rd}"
    assert actual_rd == rd, f"Load result for addr is incorrect: {actual_addr} != {addr}"
    assert actual_rd == rd, f"Load result for offset is incorrect: {actual_offset} != {offset}"
    assert actual_rd == rd, f"Load result for sext is incorrect: {actual_sext} != {sext}"
    assert actual_rd == rd, f"Load result for size is incorrect: {actual_size} != {size}"
    assert actual_rd == rd, f"Load result for en is incorrect: {actual_en} != {en}"

async def initialize_values(dut):
    dut.hrstn.value = 0
    await cocotb.start(generate_clock(dut))
    await cocotb.start(start_cycle_cnt(dut))
    await Timer(5, units="ns")
    dut.hrstn.value = 1
    await Timer(9, units="ns")
    await RisingEdge(dut.hclk)

async def initialize_cmds(dut, cmd):
    dut.dec_lb.value = (cmd == "lb")
    dut.dec_lh.value = (cmd == "lh")
    dut.dec_lw.value = (cmd == "lw")
    dut.dec_lbu.value = (cmd == "lbu")
    dut.dec_lhu.value = (cmd == "lhu")

@cocotb.test()
async def exu_load_cocotb(dut):
    """Testing loading a signed byte"""
    # Define our variables
    imm = 5
    reg_rdata_1 = 3
    cmd = "lb"
    dec_rd = 2

    
    # Assign values to the DUT
    dut.reg_rdata_1.value = reg_rdata_1
    dut.dec_imm_type_i.value = imm
    dut.dec_load_en.value = 1
    dut.dec_rd.value = dec_rd

    await initialize_cmds(dut, cmd)
    await initialize_values(dut)

    # Get the results from the model
    load_rd, load_addr, load_offset, load_sext, load_size, load_en = load_model(cmd, dec_rd, reg_rdata_1, imm) 
    # Get the actual results from the simulation
    actual_load_rd = int(str(dut.exu_load_rd.value),2)
    actual_load_addr = int(str(dut.exu_load_base_addr.value),2)
    actual_load_offset = int(str(dut.exu_load_offset.value),2)
    actual_load_sext = int(str(dut.exu_load_sext.value),2)
    actual_load_size = int(str(dut.exu_load_size.value),2)
    actual_load_en = int(str(dut.exu_load_en.value),2)
    # Report the data
    await report_data(dut, actual_load_rd, actual_load_addr, actual_load_offset, actual_load_sext, actual_load_size, actual_load_en, load_rd, load_addr, load_offset, load_sext, load_size, load_en)

@cocotb.test()
async def exu_loda_randomized_test(dut):
    """Test 50 random calls with random reg, imm, and rd values"""
    coverage = []
    for i in range(50):
        # Initialize the values
        # Set random values for the register data, immediate, and call
        imm = random.randint(0, 0xFFF)
        reg_rdata_1 = random.randint(0, 0xFFFFFFFF)
        dec_rd = random.randint(0, 0xF)
        call_sel = random.randint(0,4)
        calls = ["lb", "lh", "lw", "lbu", "lhu"]
        cmd = calls[call_sel]
        if cmd not in coverage:
            coverage.append(cmd)

        # Assign the values to the dut
        dut.reg_rdata_1.value = reg_rdata_1
        dut.dec_imm_type_i.value = imm
        dut.dec_load_en.value = 1
        dut.dec_rd.value = dec_rd

        await initialize_cmds(dut, cmd)
        await initialize_values(dut)
        

        # Get the results from the model
        load_rd, load_addr, load_offset, load_sext, load_size, load_en = load_model(cmd, dec_rd, reg_rdata_1, imm)
        # Get the actual results from the simulation
        actual_load_rd = int(str(dut.exu_load_rd.value),2)
        actual_load_addr = int(str(dut.exu_load_base_addr.value),2)
        actual_load_offset = int(str(dut.exu_load_offset.value),2)
        actual_load_sext = int(str(dut.exu_load_sext.value),2)
        actual_load_size = int(str(dut.exu_load_size.value),2)
        actual_load_en = int(str(dut.exu_load_en.value),2)
        # Report the data
        await report_data(dut, actual_load_rd, actual_load_addr, actual_load_offset, actual_load_sext, actual_load_size, actual_load_en, load_rd, load_addr, load_offset, load_sext, load_size, load_en)
        dut._log.info("____________________________________")

    dut._log.info(f"Coverage: {len(coverage)} out of 5 commands tested")


