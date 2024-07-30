library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

-- This is a simple VGA controller generating
-- pixel coordinates and synchronizarion signals
-- corresponding to a 640x480 screen resolution.
-- The input clock must be 25.175 MHz, but plain 25 MHz will work.

entity vga is
   port (
      clk_i    : in    std_logic;                    -- 25 MHz

      hs_o     : out   std_logic;                    -- Horizontal synchronization
      vs_o     : out   std_logic;                    -- Vertical synchronization
      hblank_o : out   std_logic;                    -- Horizontal synchronization
      vblank_o : out   std_logic;                    -- Vertical synchronization
      pix_x_o  : out   std_logic_vector(9 downto 0); -- Pixel coordiante x
      pix_y_o  : out   std_logic_vector(9 downto 0)  -- Pixel coordiante y
   );
end entity vga;

architecture structural of vga is

   -- Define constants used for 640x480 @ 60 Hz.
   -- Requires a clock of 25.175 MHz.
   -- See page 17 in "VESA MONITOR TIMING STANDARD"
   -- http://caxapa.ru/thumbs/361638/DMTv1r11.pdf
   constant C_H_PIXELS : integer                   := 640;
   constant C_V_PIXELS : integer                   := 480;
   --
   constant C_H_TOTAL  : integer                   := 800;
   constant C_HS_START : integer                   := 656;
   constant C_HS_TIME  : integer                   := 96;
   --
   constant C_V_TOTAL  : integer                   := 525;
   constant C_VS_START : integer                   := 490;
   constant C_VS_TIME  : integer                   := 2;

   -- Pixel counters
   signal   pix_x_r : std_logic_vector(9 downto 0) := (others => '0');
   signal   pix_y_r : std_logic_vector(9 downto 0) := (others => '0');

begin

   ---------------------------------------------------
   -- Generate horizontal and vertical pixel counters
   ---------------------------------------------------

   pix_x_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         if pix_x_r = C_H_TOTAL - 1 then
            pix_x_r <= (others => '0');
         else
            pix_x_r <= pix_x_r + 1;
         end if;
      end if;
   end process pix_x_proc;

   pix_y_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         if pix_x_r = C_H_TOTAL - 1  then
            if pix_y_r = C_V_TOTAL - 1 then
               pix_y_r <= (others => '0');
            else
               pix_y_r <= pix_y_r + 1;
            end if;
         end if;
      end if;
   end process pix_y_proc;


   --------------------------------------------------
   -- Drive output signals
   --------------------------------------------------

   hblank_o <= '1' when pix_x_r >= C_H_PIXELS else
               '0';
   vblank_o <= '1' when pix_y_r >= C_V_PIXELS else
               '0';

   hs_o     <= '1' when pix_x_r >= C_HS_START and pix_x_r < C_HS_START + C_HS_TIME else
               '0';
   vs_o     <= '1' when pix_y_r >= C_VS_START and pix_y_r < C_VS_START + C_VS_TIME else
               '0';
   pix_x_o  <= pix_x_r;
   pix_y_o  <= pix_y_r;

end architecture structural;

