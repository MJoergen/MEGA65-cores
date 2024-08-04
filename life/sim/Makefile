SRCS += ../../M2M/vhdl/av_pipeline/video_modes_pkg.vhd
SRCS += ../../M2M/vhdl/uart.vhd
SRCS += ../../M2M/vhdl/av_pipeline/vga_controller.vhd
SRCS += ../../M2M/vhdl/tdp_ram.vhd
SRCS += ../../M2M/QNICE/vhdl/tools.vhd

SRCS += ../vhdl/clk.vhd
SRCS += ../vhdl/globals.vhd
SRCS += ../vhdl/life.vhd
SRCS += ../vhdl/controller/lfsr.vhd
SRCS += ../vhdl/controller/random.vhd
SRCS += ../vhdl/controller/controller.vhd
SRCS += ../vhdl/controller/controller_wrapper.vhd
SRCS += ../vhdl/video/font.vhd
SRCS += ../vhdl/video/divexact.vhd
SRCS += ../vhdl/video/slv_to_dec.vhd
SRCS += ../vhdl/video/vga_chars.vhd
SRCS += ../vhdl/video/shift_registers.vhd
SRCS += ../vhdl/video/video_text_mode.vhd
SRCS += ../vhdl/video/video_board.vhd
SRCS += ../vhdl/video/video_wrapper.vhd
SRCS += ../vhdl/mega65_core.vhd
SRCS += uart_dumper.vhd
SRCS += tb_life.vhd
SRCS += tb_mega65_core.vhd

TB = life
TB = mega65_core

GENERICS += -gG_CELL_BITS=4
GENERICS += -gG_ROWS=89
GENERICS += -gG_COLS=160
GENERICS += -gG_BOARD=R6

all:
	vlog glbl.v
	vcom -2008 $(SRCS)
	vsim -voptargs=+acc $(GENERICS) -do wave_$(TB).do tb_$(TB) glbl


