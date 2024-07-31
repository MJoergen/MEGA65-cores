library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

-- Simple testbench for the Mandelbrot state machine
-- We start with the point -1+0.5i, i.e. cx = -1 and cy = 0.5
-- The expected sequence of points is then:
-- cnt |   x           |   y           | (x+y)*(x-y)   |  x*y
-- ----+---------------+---------------+---------------+--------
--  0  | 00000 ( 0)    | 00000 ( 0)    | 00000 ( 0)    | 00000 ( 0)
--  1  | 30000 (-1)    | 08000 ( 0.5)  | 0C000 ( 0.75) | 38000 (-0.5)
--  2  | 3C000 (-0.25) | 38000 (-0.5)  | 3D000 (-0.19) | 02000 ( 0.13)
--  3  | 2D000 (-1.19) | 0C000 ( 0.75) | 0D900 ( 0.85) | 31C00 (-0.89)
--  4  | 3D900 (-0.15) | 2B800 (-1.28) | 261B1 (-1.62) | 031F8 ( 0.20)

entity tb_iterator is
end entity tb_iterator;

architecture simulation of tb_iterator is

   signal clk : std_logic := '1';
   signal rst : std_logic := '1';

   signal start : std_logic;
   signal cx    : std_logic_vector(17 downto 0);
   signal cy    : std_logic_vector(17 downto 0);
   signal cnt   : std_logic_vector( 8 downto 0);
   signal done  : std_logic;

begin

   clk <= not clk after 5 ns; -- 100 MHz
   rst <= '1', '0' after 100 ns;


   test_proc : process
   begin
      start <= '0';
      wait for 500 ns;
      wait until clk = '1';
      cx    <= "11" & X"0000";   -- i.e. -1
      cy    <= "00" & X"8000";   -- i.e. 0.5
      start <= '1';
      wait until clk = '1';
      start <= '0';
      wait;
   end process test_proc;


   -------------------
   -- Instantiate DUT
   -------------------

   iterator_inst : entity work.iterator
      generic map (
         G_MAX_COUNT => 510
      )
      port map (
         clk_i   => clk,
         rst_i   => rst,
         start_i => start,
         cx_i    => cx,
         cy_i    => cy,
         cnt_o   => cnt,
         done_o  => done
      ); -- iterator_inst

end architecture simulation;

