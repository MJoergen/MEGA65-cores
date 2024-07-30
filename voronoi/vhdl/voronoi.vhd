library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity voronoi is
   port (
      clk_i   : in    std_logic;
      rst_i   : in    std_logic;
      move_i  : in    std_logic;
      pix_x_i : in    std_logic_vector(9 downto 0);
      pix_y_i : in    std_logic_vector(9 downto 0);
      col_o   : out   std_logic_vector(23 downto 0)
   );
end entity voronoi;

architecture structural of voronoi is

   constant C_RESOLUTION : integer := 7;
   constant C_NUM_POINTS : integer := 32;

   -- A vector of coordinates.
   type     coord_vector_type is array(natural range <>) of std_logic_vector(9 + C_RESOLUTION downto 0);

   -- Position of Voronoi points.
   signal   vx_r : coord_vector_type(C_NUM_POINTS - 1 downto 0);
   signal   vy_r : coord_vector_type(C_NUM_POINTS - 1 downto 0);

   -- Distance from current pixel to each Voronoi point.
   signal   stage0_dist : coord_vector_type(C_NUM_POINTS - 1 downto 0);
   signal   stage1_dist : coord_vector_type(C_NUM_POINTS - 1 downto 0);

   signal   stage2_mindist : std_logic_vector(9 + C_RESOLUTION downto 0);
   signal   stage2_colour  : std_logic_vector(4 downto 0);
   signal   stage3_colour  : std_logic_vector(23 downto 0);

   type     init_type is record
      startx : std_logic_vector(9 downto 0);
      starty : std_logic_vector(9 downto 0);
      velx   : std_logic_vector(3 downto 0);
      vely   : std_logic_vector(3 downto 0);
   end record init_type;

   pure function init (
      i : integer
   ) return init_type is
      variable res_v : init_type;
   begin
      -- Make sure the point is not too close to the border
      res_v.startx := to_stdlogicvector(10 + 3 * i, 10);
      res_v.starty := to_stdlogicvector(10 + 2 * i, 10);
      -- Make sure the initial velocity is not zero.
      res_v.velx   := to_stdlogicvector( 1 + ((i * i * 7)     mod 15), 4);
      res_v.vely   := to_stdlogicvector( 1 + ((i * i * i * 4) mod 15), 4);

      return res_v;
   end function init;

begin

   voronoi_gen : for i in 0 to C_NUM_POINTS - 1 generate

      -- This block moves around each Voronoi center.
      move_inst : entity work.move
         generic map (
            G_SIZE => 10
         )
         port map (
            clk_i    => clk_i,
            rst_i    => rst_i,
            startx_i => init(i).startx,
            starty_i => init(i).starty,
            velx_i   => init(i).velx,
            vely_i   => init(i).vely,
            move_i   => move_i,
            x_o      => vx_r(i)(9 + C_RESOLUTION downto C_RESOLUTION),
            y_o      => vy_r(i)(9 + C_RESOLUTION downto C_RESOLUTION)
         ); -- move_inst

      -- This is a small combinatorial block that computes the distance
      -- from the current pixel to the Voronoi center.
      dist_inst : entity work.dist
         generic map (
            G_RESOLUTION => C_RESOLUTION,
            G_SIZE       => 10
         )
         port map (
            x1_i   => vx_r(i)(9 + C_RESOLUTION downto C_RESOLUTION),
            y1_i   => vy_r(i)(9 + C_RESOLUTION downto C_RESOLUTION),
            x2_i   => pix_x_i,
            y2_i   => pix_y_i,
            dist_o => stage0_dist(i)
         ); -- dist_inst

   end generate voronoi_gen;


   ------------------------------------------------
   -- Add a line of registers to improve timing.
   ------------------------------------------------

   stage1_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         stage1_dist <= stage0_dist;
      end if;
   end process stage1_proc;


   ------------------------------------------------
   -- Determine which Voronoi point is the nearest
   ------------------------------------------------

   mindist_proc : process (clk_i)
      variable mindist1_v : std_logic_vector(9 + C_RESOLUTION downto 0);
      variable colour1_v  : std_logic_vector(4 downto 0);
      variable mindist2_v : std_logic_vector(9 + C_RESOLUTION downto 0);
      variable colour2_v  : std_logic_vector(4 downto 0);
   begin
      if rising_edge(clk_i) then
         -- Split the comparison in two, to get better timing.
         colour1_v  := "00000";
         mindist1_v := stage1_dist(0);

         for i in 1 to C_NUM_POINTS / 2 - 1 loop
            if stage1_dist(i) < mindist1_v then
               mindist1_v := stage1_dist(i);
               colour1_v  := to_stdlogicvector(i mod 32, 5);
            end if;
         end loop;

         colour2_v  := to_stdlogicvector((C_NUM_POINTS / 2) mod 32, 5);
         mindist2_v := stage1_dist(C_NUM_POINTS / 2);

         for i in C_NUM_POINTS / 2 + 1 to C_NUM_POINTS - 1 loop
            if stage1_dist(i) < mindist2_v then
               mindist2_v := stage1_dist(i);
               colour2_v  := to_stdlogicvector(i mod 32, 5);
            end if;
         end loop;

         if mindist1_v < mindist2_v then
            stage2_mindist <= mindist1_v;
            stage2_colour  <= colour1_v;
         else
            stage2_mindist <= mindist2_v;
            stage2_colour  <= colour2_v;
         end if;
      end if;
   end process mindist_proc;


   --------------------------------------------------
   -- Generate pixel colour
   --------------------------------------------------

   col_proc : process (clk_i)
      variable brightness_v : std_logic_vector(7 downto 0);
   begin
      if rising_edge(clk_i) then
         brightness_v  := not stage2_mindist(C_RESOLUTION + 7 downto C_RESOLUTION);
         case stage2_colour(4 downto 3) is
            when "00" => stage3_colour <= (others => '0');
            when "01" => stage3_colour <=
                             "0" & brightness_v(7 downto 1) &
                             "0" & brightness_v(7 downto 1) &
                             X"00";
            when "10" => stage3_colour <=
                             "0" & brightness_v(7 downto 1) &
                             X"00" &
                             "0" & brightness_v(7 downto 1);
            when "11" => stage3_colour <=
                             X"00" &
                             "0" & brightness_v(7 downto 1) &
                             "0" & brightness_v(7 downto 1);
         end case;

         if stage2_colour(0) = '0' then
            stage3_colour(7 downto 0) <= brightness_v;
         end if;

         if stage2_colour(1) = '0' then
            stage3_colour(15 downto 8) <= brightness_v;
         end if;

         if stage2_colour(2) = '0' then
            stage3_colour(23 downto 16) <= brightness_v;
         end if;
      end if;
   end process col_proc;

   col_o <= stage3_colour;

end architecture structural;

