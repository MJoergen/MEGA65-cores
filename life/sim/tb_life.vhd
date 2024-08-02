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
   signal   ready   : std_logic;
   signal   en      : std_logic;

   -- The current board status
   signal   addr    : std_logic_vector(9 downto 0);
   signal   rd_data : std_logic_vector(G_COLS-1 downto 0) := (others => '0');
   signal   wr_data : std_logic_vector(G_COLS-1 downto 0) := (others => '0');
   signal   wr_en   : std_logic;

   -- Controls the individual cells of the board
   signal   index  : integer range C_ROWS * C_COLS - 1 downto 0;
   signal   value  : std_logic;
   signal   update : std_logic;

   type     board_type is array (natural range <>) of std_logic_vector(C_COLS - 1 downto 0);
   signal   board : board_type(C_ROWS - 1 downto 0);

begin

   rst <= '1', '0' after 100 ns;
   clk <= running and not clk after 5 ns;

   life_inst : entity work.life
      generic map (
         G_ROWS => C_ROWS,
         G_COLS => C_COLS
      )
      port map (
         rst_i     => rst,
         clk_i     => clk,
         ready_o   => ready,
         step_i    => en,
         addr_o    => addr,
         rd_data_i => rd_data,
         wr_data_o => wr_data,
         wr_en_o   => wr_en
      ); -- life_inst

   board_proc : process (clk)
   begin
      if rising_edge(clk) then
         rd_data(C_COLS - 1 downto 0) <= board(to_integer(addr));
         if wr_en = '1' then
            board(to_integer(addr)) <= wr_data(C_COLS - 1 downto 0);
         end if;
         if update = '1' then
            board(index / C_COLS)(index mod C_COLS) <= value;
         end if;
         if rst = '1' then
            board <= (others => (others => '0'));
         end if;
      end if;
   end process board_proc;

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
         arg : board_type
      ) is
      begin
         --
         for i in C_ROWS - 1 downto 0 loop
            report to_string(arg(i));
         end loop;

      --
      end procedure print_board;

      procedure verify_board (
         arg : board_type
      ) is
      begin
         --

         if board /= arg then
            report "Got:";
            print_board(board);

            report "Expected:";
            print_board(arg);
         end if;

      --
      end procedure verify_board;

      --
      variable exp_board_v : board_type(C_ROWS - 1 downto 0);
   begin
      en          <= '0';
      update      <= '0';
      wait until rst = '0';
      report "Test started";

      write_cell(4, 6);
      write_cell(3, 5);
      write_cell(5, 4);
      write_cell(4, 4);
      write_cell(3, 4);

      wait until clk = '1';

      exp_board_v :=
      (
         "00000000",
         "00010000",
         "00001000",
         "00111000",
         "00000000",
         "00000000",
         "00000000",
         "00000000"
      );

      verify_board(exp_board_v);

      en          <= '1';
      wait until clk = '1';
      wait until ready = '1';

      wait until clk = '1';
      wait until ready = '1';

      wait until clk = '1';
      wait until ready = '1';

      wait until clk = '1';
      wait until ready = '1';

      en          <= '0';
      wait until clk = '1';

      exp_board_v :=
      (
         "00000000",
         "00000000",
         "00001000",
         "00000100",
         "00011100",
         "00000000",
         "00000000",
         "00000000"
      );
      verify_board(exp_board_v);

      wait until clk = '1';
      running     <= '0';
      report "Test finished";
   end process test_proc;

end architecture simulation;

