library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

library work;
   use work.video_modes_pkg.all;

entity video_board is
   generic (
      G_VIDEO_MODE : video_modes_t;
      G_NUM_QUEENS : natural
   );
   port (
      video_clk_i    : in    std_logic;
      video_rst_i    : in    std_logic;
      video_x_i      : in    std_logic_vector(7 downto 0);
      video_y_i      : in    std_logic_vector(7 downto 0);
      video_board_i  : in    std_logic_vector(G_NUM_QUEENS * G_NUM_QUEENS - 1 downto 0);
      video_char_o   : out   std_logic_vector(7 downto 0);
      video_colors_o : out   std_logic_vector(15 downto 0)
   );
end entity video_board;

architecture synthesis of video_board is

   -- Define colours
   constant C_PIXEL_DARK  : std_logic_vector(7 downto 0) := B"001_001_01";
   constant C_PIXEL_GREY  : std_logic_vector(7 downto 0) := B"010_010_01";
   constant C_PIXEL_LIGHT : std_logic_vector(7 downto 0) := B"100_100_10";

   constant C_START_X : std_logic_vector(7 downto 0)     := to_stdlogicvector(G_VIDEO_MODE.H_PIXELS / 16 - G_NUM_QUEENS / 2, 8);
   constant C_START_Y : std_logic_vector(7 downto 0)     := to_stdlogicvector(G_VIDEO_MODE.V_PIXELS / 16 - G_NUM_QUEENS / 2, 8);

begin

   char_proc : process (video_clk_i)
      variable video_index_v     : natural range 0 to G_NUM_QUEENS * G_NUM_QUEENS - 1;
      variable video_dec_index_v : natural range 0 to 4;
   begin
      if rising_edge(video_clk_i) then
         video_colors_o <= C_PIXEL_GREY & C_PIXEL_GREY;
         video_char_o   <= X"20";

         if video_x_i >= C_START_X and video_x_i < C_START_X + G_NUM_QUEENS and
            video_y_i >= C_START_Y and video_y_i < C_START_Y + G_NUM_QUEENS then
            video_index_v := to_integer((G_NUM_QUEENS - 1 - (video_y_i - C_START_Y)) * G_NUM_QUEENS + (G_NUM_QUEENS - 1 - (video_x_i - C_START_X)));
            if video_board_i(video_index_v) = '1' then
               video_char_o <= X"58";
            else
               video_char_o <= X"2E";
            end if;
            video_colors_o <= C_PIXEL_DARK & C_PIXEL_LIGHT;
         end if;
         if video_x_i >= C_START_X + 5 and video_x_i < C_START_X + G_NUM_QUEENS and
            video_y_i = C_START_Y + G_NUM_QUEENS then
            video_colors_o <= C_PIXEL_DARK & C_PIXEL_LIGHT;
         end if;
      end if;
   end process char_proc;

end architecture synthesis;

