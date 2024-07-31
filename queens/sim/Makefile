SRCS += ../../M2M/vhdl/av_pipeline/video_modes_pkg.vhd
SRCS += ../../M2M/vhdl/stringifier.vhd
SRCS += ../../M2M/vhdl/serializer.vhd
SRCS += ../../M2M/vhdl/uart.vhd
SRCS += ../../M2M/vhdl/av_pipeline/vga_controller.vhd
SRCS += ../../M2M/QNICE/vhdl/tools.vhd

SRCS += ../vhdl/clk.vhd
SRCS += ../vhdl/globals.vhd
SRCS += ../vhdl/queens.vhd
SRCS += ../vhdl/controller/controller.vhd
SRCS += ../vhdl/controller/controller_wrapper.vhd
SRCS += ../vhdl/video/font.vhd
SRCS += ../vhdl/video/vga_chars.vhd
SRCS += ../vhdl/video/shift_registers.vhd
SRCS += ../vhdl/video/video_text_mode.vhd
SRCS += ../vhdl/video/video_board.vhd
SRCS += ../vhdl/video/video_wrapper.vhd
SRCS += ../vhdl/mega65_core.vhd
SRCS += tb_mega65_core.vhd

GENERICS += -gG_NUM_QUEENS=8
GENERICS += -gG_BOARD=R6

WAVE = wave.do

all:
	vlog glbl.v
	vcom -2008 $(SRCS)
	vsim -voptargs=+acc $(GENERICS) -do $(WAVE) tb_mega65_core glbl

