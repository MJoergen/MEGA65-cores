----------------------------------------------------------------------------------
-- The file contains a unit test for the life demo.
----------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity tb_life is
   generic (
      G_ROWS : integer;
      G_COLS : integer
   );
end entity tb_life;

architecture simulation of tb_life is

   constant C_ROWS : integer    := G_ROWS;
   constant C_COLS : integer    := G_COLS;

   -- Clock, reset, and enable
   signal   running : std_logic := '1';
   signal   rst     : std_logic := '1';
   signal   clk     : std_logic := '1';
   signal   en      : std_logic;

   -- The current board status
   signal   board : std_logic_vector(C_ROWS * C_COLS - 1 downto 0);

   -- Controls the individual cells of the board
   signal   index  : integer range C_ROWS * C_COLS - 1 downto 0;
   signal   value  : std_logic;
   signal   update : std_logic;

   pure function reverse (
      arg : std_logic_vector
   ) return std_logic_vector is
      variable res_v : std_logic_vector(arg'range);
   begin
      --
      for i in arg'range loop
         res_v(i) := arg(arg'length-1 - i);
      end loop;

      return res_v;
   end function reverse;

begin

   rst <= '1', '0' after 100 ns;
   clk <= running and not clk after 5 ns;

   life_inst : entity work.life
      generic map (
         G_ROWS => C_ROWS,
         G_COLS => C_COLS
      )
      port map (
         rst_i    => rst,
         clk_i    => clk,
         en_i     => en,
         board_o  => board,
         index_i  => index,
         value_i  => value,
         update_i => update
      ); -- life_inst

   test_proc : process
      --

      procedure write_cell (
         col : integer range 0 to C_COLS - 1;
         row : integer range 0 to C_ROWS - 1
      ) is
      begin
         index  <= row * C_COLS + col;
         value  <= '1';
         update <= '1';
         wait until clk = '1';
         update <= '0';
      end procedure write_cell;


      procedure print_board (
         arg : std_logic_vector
      ) is
         variable arg_v : std_logic_vector(G_ROWS * G_COLS - 1 downto 0);
      begin
         arg_v := arg;
         --
         for i in 0 to C_ROWS - 1 loop
            report to_string(arg_v((i + 1) * C_COLS - 1 downto i * C_COLS));
         end loop;

      --
      end procedure print_board;

      procedure verify_board (
         arg : std_logic_vector
      ) is
      begin
         if board /= reverse(arg) then
            report "Got:";
            print_board(board);

            report "Expected:";
            print_board(reverse(arg));
         end if;
      end procedure verify_board;

   --
   begin
      en      <= '0';
      update  <= '0';
      wait until rst = '0';
      report "Test started";

      write_cell(3, 1);
      write_cell(4, 2);
      write_cell(2, 3);
      write_cell(3, 3);
      write_cell(4, 3);

      wait until clk = '1';

      verify_board(
                   "00000000" &
                   "00010000" &
                   "00001000" &
                   "00111000" &
                   "00000000" &
                   "00000000" &
                   "00000000" &
                   "00000000");

      en      <= '1';
      wait until clk = '1';
      wait until clk = '1';
      wait until clk = '1';
      wait until clk = '1';
      en      <= '0';
      wait until clk = '1';

      verify_board(
                   "00000000" &
                   "00000000" &
                   "00001000" &
                   "00000100" &
                   "00011100" &
                   "00000000" &
                   "00000000" &
                   "00000000");

      wait until clk = '1';
      running <= '0';
      report "Test finished";
   end process test_proc;

end architecture simulation;

