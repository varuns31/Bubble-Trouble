transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib lab7soc
vmap lab7soc lab7soc
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis {C:/lab7jaia2andvarun/lab7soc/synthesis/lab7soc.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_avalon_st_adapter_005.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_usb_rst.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_timer_0.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_sysid_qsys_0.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_spi_0.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_sdram_pll.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_sdram.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_onchip_memory2_0.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_nios2_gen2_0.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_nios2_gen2_0_cpu.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_nios2_gen2_0_cpu_debug_slave_sysclk.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_nios2_gen2_0_cpu_debug_slave_tck.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_nios2_gen2_0_cpu_debug_slave_wrapper.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_nios2_gen2_0_cpu_test_bench.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_leds_pio.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_keycode.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_key.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_jtag_uart_0.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_hex_digits_pio.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_Button.v}
vlog -sv -work work +incdir+C:/lab7jaia2andvarun/Lab\ 7\ alt_material {C:/lab7jaia2andvarun/Lab 7 alt_material/vga_text_avl_interface.sv}
vlog -sv -work work +incdir+C:/lab7jaia2andvarun/Lab\ 7\ alt_material {C:/lab7jaia2andvarun/Lab 7 alt_material/lab7.sv}
vlog -sv -work work +incdir+C:/lab7jaia2andvarun {C:/lab7jaia2andvarun/HexDriver.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_irq_mapper.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_avalon_st_adapter_005_error_adapter_0.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_avalon_st_handshake_clock_crosser.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -vlog01compat -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_std_synchronizer_nocut.v}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_width_adapter.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_rsp_demux_010.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_cmd_mux_010.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_burst_adapter_uncmpr.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_router_012.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_router_007.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_router_002.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_router_001.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/lab7soc_mm_interconnect_0_router.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work lab7soc +incdir+C:/lab7jaia2andvarun/lab7soc/synthesis/submodules {C:/lab7jaia2andvarun/lab7soc/synthesis/submodules/vga_text_avl_interface.sv}

vlog -sv -work work +incdir+C:/lab7jaia2andvarun {C:/lab7jaia2andvarun/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -L lab7soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1 sec
