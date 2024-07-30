SRCS += ../../M2M/vhdl/av_pipeline/video_modes_pkg.vhd

SRCS += ../vhdl/clk.vhd
SRCS += ../vhdl/stringifier.vhd
SRCS += ../vhdl/serializer.vhd
SRCS += ../vhdl/queens.vhd
SRCS += ../vhdl/uart_wrapper.vhd
SRCS += ../vhdl/uart.vhd
SRCS += ../vhdl/mega65_core.vhd
SRCS += tb_mega65_core.vhd

GENERICS += -gG_NUM_QUEENS=8
GENERICS += -gG_BOARD=R6

WAVE = wave.do

all:
	vlog glbl.v
	vcom -2008 $(SRCS)
	vsim -voptargs=+acc $(GENERICS) -do $(WAVE) tb_mega65_core glbl

