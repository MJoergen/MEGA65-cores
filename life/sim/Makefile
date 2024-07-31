SRCS += ../../M2M/vhdl/av_pipeline/video_modes_pkg.vhd
SRCS += ../../M2M/vhdl/uart.vhd
SRCS += ../../M2M/vhdl/av_pipeline/vga_controller.vhd

SRCS += ../vhdl/clk.vhd
SRCS += ../vhdl/life.vhd
SRCS += ../vhdl/controller.vhd
SRCS += ../vhdl/font.vhd
SRCS += ../vhdl/divexact.vhd
SRCS += ../vhdl/slv_to_dec.vhd
SRCS += ../vhdl/vga_chars.vhd
SRCS += ../vhdl/vga_wrapper.vhd
SRCS += ../vhdl/shift_registers.vhd
SRCS += ../vhdl/video_wrapper.vhd
SRCS += ../vhdl/mega65_core.vhd
SRCS += uart_dumper.vhd
SRCS += tb_mega65_core.vhd

GENERICS += -gG_ROWS=8
GENERICS += -gG_COLS=8
GENERICS += -gG_CELLS_INIT="16'h1020304050607080"
GENERICS += -gG_BOARD=R6

WAVE = wave.do

all:
	vlog glbl.v
	vcom -2008 $(SRCS)
	vsim -voptargs=+acc $(GENERICS) -do $(WAVE) tb_mega65_core glbl

