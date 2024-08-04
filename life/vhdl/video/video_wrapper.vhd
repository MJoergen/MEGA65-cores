library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

library work;
   use work.video_modes_pkg.all;

entity video_wrapper is
   generic (
      G_VIDEO_MODE : video_modes_t;
      G_FONT_PATH  : string := "";
      G_CELL_BITS  : integer;
      G_ROWS       : integer;
      G_COLS       : integer
   );
   port (
      video_clk_i    : in    std_logic;
      video_rst_i    : in    std_logic;
      video_count_i  : in    std_logic_vector(15 downto 0);
      video_gens_i   : in    std_logic_vector(15 downto 0);
      video_addr_o   : out   std_logic_vector(9 downto 0);
      video_data_i   : in    std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      video_ce_o     : out   std_logic;
      video_ce_ovl_o : out   std_logic;
      video_red_o    : out   std_logic_vector(7 downto 0);
      video_green_o  : out   std_logic_vector(7 downto 0);
      video_blue_o   : out   std_logic_vector(7 downto 0);
      video_vs_o     : out   std_logic;
      video_hs_o     : out   std_logic;
      video_hblank_o : out   std_logic;
      video_vblank_o : out   std_logic
   );
end entity video_wrapper;

architecture synthesis of video_wrapper is

   signal video_x      : std_logic_vector(7 downto 0);
   signal video_y      : std_logic_vector(7 downto 0);
   signal video_char   : std_logic_vector(7 downto 0);
   signal video_colors : std_logic_vector(15 downto 0);

begin

   video_board_inst : entity work.video_board
      generic map (
         G_VIDEO_MODE => G_VIDEO_MODE,
         G_CELL_BITS  => G_CELL_BITS,
         G_ROWS       => G_ROWS,
         G_COLS       => G_COLS
      )
      port map (
         video_clk_i    => video_clk_i,
         video_rst_i    => video_rst_i,
         video_count_i  => video_count_i,
         video_gens_i   => video_gens_i,
         video_addr_o   => video_addr_o,
         video_data_i   => video_data_i,
         video_x_i      => video_x,
         video_y_i      => video_y,
         video_char_o   => video_char,
         video_colors_o => video_colors
      ); -- video_board_inst

   video_text_mode_inst : entity work.video_text_mode
      generic map (
         G_VIDEO_MODE => G_VIDEO_MODE,
         G_FONT_PATH  => G_FONT_PATH
      )
      port map (
         video_clk_i    => video_clk_i,
         video_rst_i    => video_rst_i,
         video_x_o      => video_x,
         video_y_o      => video_y,
         video_char_i   => video_char,
         video_colors_i => video_colors,
         video_ce_o     => video_ce_o,
         video_ce_ovl_o => video_ce_ovl_o,
         video_red_o    => video_red_o,
         video_green_o  => video_green_o,
         video_blue_o   => video_blue_o,
         video_vs_o     => video_vs_o,
         video_hs_o     => video_hs_o,
         video_hblank_o => video_hblank_o,
         video_vblank_o => video_vblank_o
      ); -- video_text_mode_inst

end architecture synthesis;

