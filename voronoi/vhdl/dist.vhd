library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

-- This is a small combinatorial block that computes the distance
-- between two points.

entity dist is
   generic (
      G_RESOLUTION : integer;
      G_SIZE       : integer
   );
   port (
      x1_i   : in    std_logic_vector(G_SIZE - 1 downto 0);
      y1_i   : in    std_logic_vector(G_SIZE - 1 downto 0);
      x2_i   : in    std_logic_vector(G_SIZE - 1 downto 0);
      y2_i   : in    std_logic_vector(G_SIZE - 1 downto 0);
      dist_o : out   std_logic_vector(G_SIZE + G_RESOLUTION - 1 downto 0)
   );
end entity dist;

architecture structural of dist is

   signal xmin_s : std_logic_vector(G_SIZE - 1 downto 0);
   signal xmax_s : std_logic_vector(G_SIZE - 1 downto 0);
   signal ymin_s : std_logic_vector(G_SIZE - 1 downto 0);
   signal ymax_s : std_logic_vector(G_SIZE - 1 downto 0);

   -- These contain the horizontal and vertical displacements.
   signal xdist_s : std_logic_vector(G_SIZE - 1 downto 0);
   signal ydist_s : std_logic_vector(G_SIZE - 1 downto 0);

begin

   -- Sort the x coordinates.
   minmax_x_inst : entity work.minmax
      generic map (
         G_SIZE => G_SIZE
      )
      port map (
         a_i   => x1_i,
         b_i   => x2_i,
         min_o => xmin_s,
         max_o => xmax_s
      ); -- minmax_x_inst

   -- Sort the y coordinates.
   minmax_y_inst : entity work.minmax
      generic map (
         G_SIZE => G_SIZE
      )
      port map (
         a_i   => y1_i,
         b_i   => y2_i,
         min_o => ymin_s,
         max_o => ymax_s
      ); -- minmax_y_inst

   -- Calculate the x and y displacements.
   xdist_s <= xmax_s - xmin_s;
   ydist_s <= ymax_s - ymin_s;

   -- Calculate the distance.
   rms_inst : entity work.rms
      generic map (
         G_RESOLUTION => G_RESOLUTION,
         G_SIZE       => G_SIZE
      )
      port map (
         x_i   => xdist_s,
         y_i   => ydist_s,
         rms_o => dist_o
      ); -- rms_inst

end architecture structural;

