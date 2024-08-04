----------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework
--
-- Global constants
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
----------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

library work;
   use work.qnice_tools.all;

package globals is

   -- The following constants are needed by the M2M framework

   constant QNICE_FIRMWARE       : string                        := "../../m2m-rom/m2m-rom.rom";

   constant BOARD_CLK_SPEED      : natural                       := 100_000_000;
   constant CORE_CLK_SPEED       : natural                       := 125_000_000;

   constant VGA_DX               : natural                       := 1280;
   constant VGA_DY               : natural                       := 720;

   constant FONT_FILE            : string                        := "../font/Anikki-16x16-m2m.rom";
   constant FONT_DX              : natural                       := 16;
   constant FONT_DY              : natural                       := 16;

   constant CHARS_DX             : natural                       := VGA_DX / FONT_DX;
   constant CHARS_DY             : natural                       := VGA_DY / FONT_DY;
   constant CHAR_MEM_SIZE        : natural                       := CHARS_DX * CHARS_DY;
   constant VRAM_ADDR_WIDTH      : natural                       := f_log2(CHAR_MEM_SIZE);

   type     vd_buf_array is array (natural range <>) of std_logic_vector(15 downto 0);
   constant C_VDNUM              : natural                       := 1;
   constant C_VD_DEVICE          : std_logic_vector(15 downto 0) := x"0110";
   constant C_VD_BUFFER          : vd_buf_array                  := (x"0111", x"EEEE");

   type     crtrom_buf_array is array (natural range<>) of std_logic_vector;
   constant ENDSTR               : character                     := character'val(0);
   constant C_CRTROMS_MAN_NUM    : natural                       := 0;
   constant C_CRTROMS_MAN        : crtrom_buf_array              := (x"EEEE", x"EEEE", x"EEEE");
   constant C_CRTROMS_AUTO_NUM   : natural                       := 0;
   constant C_CRTROMS_AUTO       : crtrom_buf_array              := (x"EEEE", x"EEEE", x"EEEE", x"EEEE", x"EEEE");
   constant C_CRTROMS_AUTO_NAMES : string                        := "" & ENDSTR;

   constant AUDIO_FLT_RATE       : std_logic_vector(31 downto 0) := std_logic_vector(to_signed(7056000, 32));
   constant AUDIO_CX             : std_logic_vector(39 downto 0) := std_logic_vector(to_signed(4258969, 40));
   constant AUDIO_CX0            : std_logic_vector( 7 downto 0) := std_logic_vector(to_signed(3, 8));
   constant AUDIO_CX1            : std_logic_vector( 7 downto 0) := std_logic_vector(to_signed(2, 8));
   constant AUDIO_CX2            : std_logic_vector( 7 downto 0) := std_logic_vector(to_signed(1, 8));
   constant AUDIO_CY0            : std_logic_vector(23 downto 0) := std_logic_vector(to_signed(-6216759, 24));
   constant AUDIO_CY1            : std_logic_vector(23 downto 0) := std_logic_vector(to_signed( 6143386, 24));
   constant AUDIO_CY2            : std_logic_vector(23 downto 0) := std_logic_vector(to_signed(-2023767, 24));
   constant AUDIO_ATT            : std_logic_vector( 4 downto 0) := "00000";
   constant AUDIO_MIX            : std_logic_vector( 1 downto 0) := "00";

end package globals;

