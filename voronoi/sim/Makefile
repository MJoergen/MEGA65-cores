SRCS += ../../M2M/vhdl/av_pipeline/video_modes_pkg.vhd

SRCS += ../vhdl/clk.vhd
SRCS += ../vhdl/minmax.vhd
SRCS += ../vhdl/rms.vhd
SRCS += ../vhdl/dist.vhd
SRCS += ../vhdl/move.vhd
SRCS += ../vhdl/vga.vhd
SRCS += ../vhdl/voronoi.vhd
SRCS += ../vhdl/mega65_core.vhd
SRCS += tb_mega65_core.vhd

GENERICS += -gG_BOARD=R6

WAVE = wave.do

all:
	vlog glbl.v
	vcom -2008 $(SRCS)
	vsim -voptargs=+acc $(GENERICS) -do $(WAVE) tb_mega65_core glbl

