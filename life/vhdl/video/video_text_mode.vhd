library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

library work;
   use work.video_modes_pkg.all;

entity video_text_mode is
   generic (
      G_VIDEO_MODE : video_modes_t;
      G_FONT_PATH  : string := ""
   );
   port (
      video_clk_i    : in    std_logic;
      video_rst_i    : in    std_logic;
      video_x_o      : out   std_logic_vector(7 downto 0);
      video_y_o      : out   std_logic_vector(7 downto 0);
      video_char_i   : in    std_logic_vector(7 downto 0);
      video_colors_i : in    std_logic_vector(15 downto 0);
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
end entity video_text_mode;

architecture synthesis of video_text_mode is

   signal video_hs     : std_logic;
   signal video_vs     : std_logic;
   signal video_hblank : std_logic;
   signal video_vblank : std_logic;
   signal video_pix_x  : natural range 0 to 2047;
   signal video_pix_y  : natural range 0 to 2047;

   signal slr_in  : std_logic_vector(3 downto 0);
   signal slr_out : std_logic_vector(3 downto 0);

   signal video_rgb : std_logic_vector(23 downto 0);

begin

   vga_controller_inst : entity work.vga_controller
      port map (
         clk_i    => video_clk_i,
         ce_i     => '1',
         reset_n  => not video_rst_i,
         h_pulse  => G_VIDEO_MODE.H_PULSE,
         h_bp     => G_VIDEO_MODE.H_BP,
         h_pixels => G_VIDEO_MODE.H_PIXELS,
         h_fp     => G_VIDEO_MODE.H_FP,
         h_pol    => '1',
         v_pulse  => G_VIDEO_MODE.V_PULSE,
         v_bp     => G_VIDEO_MODE.V_BP,
         v_pixels => G_VIDEO_MODE.V_PIXELS,
         v_fp     => G_VIDEO_MODE.V_FP,
         v_pol    => '1',
         h_sync   => video_hs,
         v_sync   => video_vs,
         h_blank  => video_hblank,
         v_blank  => video_vblank,
         column   => video_pix_x,
         row      => video_pix_y,
         n_blank  => open,
         n_sync   => open
      ); -- vga_controller_inst

   slr_in                                                   <= (video_hs, video_vs, video_hblank, video_vblank);
   (video_hs_o, video_vs_o, video_hblank_o, video_vblank_o) <= slr_out;

   shift_registers_inst : entity work.shift_registers
      generic map (
         G_DATA_SIZE => 4,
         G_DEPTH     => 3
      )
      port map (
         clk_i   => video_clk_i,
         clken_i => '1',
         data_i  => slr_in,
         data_o  => slr_out
      ); -- shift_registers_inst

   vga_chars_inst : entity work.vga_chars
      generic map (
         G_FONT_FILE  => G_FONT_PATH & "font8x8.txt",
         G_VIDEO_MODE => G_VIDEO_MODE
      )
      port map (
         vga_clk_i    => video_clk_i,
         vga_hcount_i => std_logic_vector(to_unsigned(video_pix_x, 11)),
         vga_vcount_i => std_logic_vector(to_unsigned(video_pix_y, 11)),
         vga_blank_i  => video_hblank or video_vblank,
         vga_x_o      => video_x_o,
         vga_y_o      => video_y_o,
         vga_char_i   => video_char_i,
         vga_colors_i => video_colors_i,
         vga_rgb_o    => video_rgb
      ); -- vga_chars_inst

   video_ce_o     <= '1';
   video_ce_ovl_o <= '1';
   video_red_o    <= video_rgb(23 downto 16);
   video_green_o  <= video_rgb(15 downto 8);
   video_blue_o   <= video_rgb(7 downto 0);

end architecture synthesis;

