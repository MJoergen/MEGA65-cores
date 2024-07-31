SRCS += ../../M2M/vhdl/av_pipeline/video_modes_pkg.vhd
SRCS += ../../M2M/vhdl/av_pipeline/vga_controller.vhd

SRCS += ../vhdl/clk.vhd
SRCS += ../vhdl/main/add_overflow.vhd
SRCS += ../vhdl/main/iterator.vhd
SRCS += ../vhdl/main/column.vhd
SRCS += ../vhdl/main/priority.vhd
SRCS += ../vhdl/main/priority_pipeline.vhd
SRCS += ../vhdl/main/scheduler.vhd
SRCS += ../vhdl/main/dispatcher.vhd
SRCS += ../vhdl/disp_mem.vhd
SRCS += ../vhdl/controller.vhd
SRCS += ../vhdl/video/shift_registers.vhd
SRCS += ../vhdl/video/video_wrapper.vhd
SRCS += ../vhdl/mega65_core.vhd
SRCS += tb_mega65_core.vhd
SRCS += tb_column.vhd
SRCS += tb_dispatcher.vhd
SRCS += tb_iterator.vhd
SRCS += tb_mult.vhd
SRCS += tb_priority_pipeline.vhd

TB = mult
TB = iterator
TB = column
TB = dispatcher
TB = priority_pipeline
TB = mega65_core

GENERICS += -gG_BOARD=R6

all:
	vlog glbl.v
	vcom -2008 $(SRCS)
	vsim -voptargs=+acc $(GENERICS) -do wave_$(TB).do tb_$(TB) glbl

