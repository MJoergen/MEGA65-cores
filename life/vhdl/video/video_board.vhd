library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

library work;
   use work.video_modes_pkg.all;

entity video_board is
   generic (
      G_VIDEO_MODE : video_modes_t;
      G_CELL_BITS  : integer;
      G_ROWS       : integer;
      G_COLS       : integer
   );
   port (
      video_clk_i    : in    std_logic;
      video_rst_i    : in    std_logic;
      video_x_i      : in    std_logic_vector(7 downto 0);
      video_y_i      : in    std_logic_vector(7 downto 0);
      video_gens_i   : in    std_logic_vector(15 downto 0);
      video_count_i  : in    std_logic_vector(15 downto 0);
      video_addr_o   : out   std_logic_vector(9 downto 0);
      video_data_i   : in    std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      video_char_o   : out   std_logic_vector(7 downto 0);
      video_colors_o : out   std_logic_vector(15 downto 0)
   );
end entity video_board;

architecture synthesis of video_board is

   -- Define colours
   constant C_PIXEL_DARK  : std_logic_vector(7 downto 0) := B"001_001_01";
   constant C_PIXEL_GREY  : std_logic_vector(7 downto 0) := B"010_010_01";
   constant C_PIXEL_LIGHT : std_logic_vector(7 downto 0) := B"100_100_10";

   constant C_START_X : std_logic_vector(7 downto 0)     := to_stdlogicvector(G_VIDEO_MODE.H_PIXELS / 16 - (G_COLS + 1) / 2, 8);
   constant C_START_Y : std_logic_vector(7 downto 0)     := to_stdlogicvector(G_VIDEO_MODE.V_PIXELS / 16 - (G_ROWS + 1) / 2, 8);

   signal   video_dec_gens_valid : std_logic;
   signal   video_dec_gens_ready : std_logic;
   signal   video_dec_gens_data  : std_logic_vector(3 downto 0);
   signal   video_dec_gens_last  : std_logic;
   signal   video_dec_gens_str   : std_logic_vector(39 downto 0);

   signal   video_dec_count_valid : std_logic;
   signal   video_dec_count_ready : std_logic;
   signal   video_dec_count_data  : std_logic_vector(3 downto 0);
   signal   video_dec_count_last  : std_logic;
   signal   video_dec_count_str   : std_logic_vector(39 downto 0);

begin

   video_addr_o <= to_stdlogicvector(to_integer(video_y_i - C_START_Y), 10);

   char_proc : process (video_clk_i)
      variable video_dec_index_v : natural range 0 to 4;
      variable col_v             : natural range 0 to G_COLS - 1;
      variable cell_v            : std_logic_vector(G_CELL_BITS - 1 downto 0);
   begin
      if rising_edge(video_clk_i) then
         video_colors_o <= C_PIXEL_GREY & C_PIXEL_GREY;
         video_char_o   <= X"20";

         if video_x_i >= C_START_X and video_x_i < C_START_X + G_COLS and
            video_y_i >= C_START_Y and video_y_i < C_START_Y + G_ROWS then
            col_v  := to_integer(video_x_i - C_START_X);
            cell_v := video_data_i((col_v + 1) * G_CELL_BITS - 1 downto col_v * G_CELL_BITS);
            if or (cell_v) = '1' then
               video_char_o <= X"58";
            else
               video_char_o <= X"2E";
            end if;
            video_colors_o <= C_PIXEL_DARK & (C_PIXEL_LIGHT / (2 ** G_CELL_BITS - to_integer(cell_v)));
         end if;
         if video_x_i >= C_START_X and video_x_i < C_START_X + 5 and
            video_y_i = C_START_Y + G_ROWS then
            video_dec_index_v := to_integer(video_x_i - C_START_X);
            video_char_o      <= video_dec_gens_str(8 * video_dec_index_v + 7 downto 8 * video_dec_index_v);
            video_colors_o    <= C_PIXEL_DARK & C_PIXEL_LIGHT;
         end if;
         if video_x_i >= C_START_X + 5 and video_x_i < C_START_X + 10 and
            video_y_i = C_START_Y + G_ROWS then
            video_colors_o <= C_PIXEL_DARK & C_PIXEL_LIGHT;
         end if;
         if video_x_i >= C_START_X + 10 and video_x_i < C_START_X + 15 and
            video_y_i = C_START_Y + G_ROWS then
            video_dec_index_v := to_integer(video_x_i - (C_START_X + 10));
            video_char_o      <= video_dec_count_str(8 * video_dec_index_v + 7 downto 8 * video_dec_index_v);
            video_colors_o    <= C_PIXEL_DARK & C_PIXEL_LIGHT;
         end if;
         if video_x_i >= C_START_X + 15 and video_x_i < C_START_X + G_COLS and
            video_y_i = C_START_Y + G_ROWS then
            video_colors_o <= C_PIXEL_DARK & C_PIXEL_LIGHT;
         end if;
      end if;
   end process char_proc;

   slv_to_dec_gens_inst : entity work.slv_to_dec
      generic map (
         G_DATA_SIZE => 16
      )
      port map (
         clk_i     => video_clk_i,
         rst_i     => video_rst_i,
         s_valid_i => '1',
         s_ready_o => open,
         s_data_i  => video_gens_i,
         m_valid_o => video_dec_gens_valid,
         m_ready_i => video_dec_gens_ready,
         m_data_o  => video_dec_gens_data,
         m_last_o  => video_dec_gens_last
      ); -- slv_to_dec_gens_inst

   slv_to_dec_count_inst : entity work.slv_to_dec
      generic map (
         G_DATA_SIZE => 16
      )
      port map (
         clk_i     => video_clk_i,
         rst_i     => video_rst_i,
         s_valid_i => '1',
         s_ready_o => open,
         s_data_i  => video_count_i,
         m_valid_o => video_dec_count_valid,
         m_ready_i => video_dec_count_ready,
         m_data_o  => video_dec_count_data,
         m_last_o  => video_dec_count_last
      ); -- slv_to_dec_count_inst

   video_dec_gens_ready  <= '1';

   video_dec_gens_proc : process (video_clk_i)
      variable tmp_v : std_logic_vector(39 downto 0);
   begin
      if rising_edge(video_clk_i) then
         if video_dec_gens_valid then
            tmp_v := "0011" & video_dec_gens_data & tmp_v(39 downto 8);
            if video_dec_gens_last then
               video_dec_gens_str <= tmp_v;
               tmp_v              := X"2020202020";
            end if;
         end if;
      end if;
   end process video_dec_gens_proc;

   video_dec_count_ready <= '1';

   video_dec_count_proc : process (video_clk_i)
      variable tmp_v : std_logic_vector(39 downto 0);
   begin
      if rising_edge(video_clk_i) then
         if video_dec_count_valid then
            tmp_v := "0011" & video_dec_count_data & tmp_v(39 downto 8);
            if video_dec_count_last then
               video_dec_count_str <= tmp_v;
               tmp_v               := X"2020202020";
            end if;
         end if;
      end if;
   end process video_dec_count_proc;

end architecture synthesis;

