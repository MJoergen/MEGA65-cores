----------------------------------------------------------------------------------
-- The file contains a unit test for the life demo.
----------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity tb_life is
   generic (
      G_CELL_BITS : integer;
      G_ROWS      : integer;
      G_COLS      : integer
   );
end entity tb_life;

architecture simulation of tb_life is

   -- Clock, reset, and enable
   signal running : std_logic                                           := '1';
   signal rst     : std_logic                                           := '1';
   signal clk     : std_logic                                           := '1';
   signal ready   : std_logic;
   signal en      : std_logic;

   -- The current board status
   signal addr    : std_logic_vector(9 downto 0);
   signal rd_data : std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0) := (others => '0');
   signal wr_data : std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0) := (others => '0');
   signal wr_en   : std_logic;

   -- Controls the individual cells of the board
   signal tb_wr_row   : integer range G_ROWS - 1 downto 0;
   signal tb_wr_col   : integer range G_COLS - 1 downto 0;
   signal tb_wr_value : std_logic_vector(G_CELL_BITS - 1 downto 0);
   signal tb_wr_en    : std_logic;

   type   board_type is array (natural range <>) of std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
   signal board : board_type(G_ROWS - 1 downto 0);

begin

   rst <= '1', '0' after 100 ns;
   clk <= running and not clk after 5 ns;

   life_inst : entity work.life
      generic map (
         G_CELL_BITS => G_CELL_BITS,
         G_ROWS      => G_ROWS,
         G_COLS      => G_COLS
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
         rd_data <= board(to_integer(addr));
         if wr_en = '1' then
            board(to_integer(addr)) <= wr_data;
         end if;
         if tb_wr_en = '1' then
            board(tb_wr_row)((tb_wr_col + 1) * G_CELL_BITS - 1 downto tb_wr_col * G_CELL_BITS) <= tb_wr_value;
         end if;
         if rst = '1' then
            board <= (others => (others => '0'));
         end if;
      end if;
   end process board_proc;

   test_proc : process
      --

      procedure write_cell (
         col : integer range 0 to G_COLS - 1;
         row : integer range 0 to G_ROWS - 1;
         val : integer range 0 to 2 ** G_CELL_BITS - 1
      )
         is
      begin
         tb_wr_row   <= row;
         tb_wr_col   <= col;
         tb_wr_value <= to_stdlogicvector(val, G_CELL_BITS);
         tb_wr_en    <= '1';
         wait until clk = '1';
         tb_wr_en    <= '0';
      end procedure write_cell;

      procedure
         print_board (
         arg : board_type
      ) is
      begin
         --
         for i in G_ROWS - 1 downto 0 loop
            report to_string(arg(i));
         end loop;

      --
      end procedure print_board;

      procedure verify_board (
         arg : board_type
      ) is
         variable board_row_v  : std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
         variable board_cell_v : std_logic_vector(G_CELL_BITS - 1 downto 0);
         variable exp_row_v    : std_logic_vector(4 * G_COLS - 1 downto 0);
         variable exp_cell_v   : std_logic_vector(3 downto 0);
         variable error_v      : boolean;
      begin
         error_v := false;
         --
         for i in arg'range loop
            board_row_v  := board(i / G_COLS);
            board_cell_v := board_row_v((i + 1) * G_CELL_BITS - 1 downto i * G_CELL_BITS);
            exp_row_v    := arg(i / G_COLS);
            exp_cell_v   := exp_row_v((i + 1) * 4 - 1 downto i * 4);
            if to_integer(board_cell_v) /= to_integer(exp_cell_v) then
               error_v := true;
            end if;
         end loop;

         if error_v then
            report "Got:";
            print_board(board);

            report "Expected:";
            print_board(arg);
         end if;
      --
      end procedure verify_board;

      --
      variable exp_board_v : board_type(G_ROWS - 1 downto 0);
   begin
      en          <= '0';
      tb_wr_en    <= '0';
      wait until rst = '0';
      report "Test started";

      write_cell(4, 6, 7);
      write_cell(3, 5, 7);
      write_cell(5, 4, 7);
      write_cell(4, 4, 7);
      write_cell(3, 4, 7);

      wait until clk = '1';

      exp_board_v :=
      (
         X"00000000",
         X"00070000",
         X"00007000",
         X"00777000",
         X"00000000",
         X"00000000",
         X"00000000",
         X"00000000"
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
         X"00000000",
         X"00000000",
         X"00001000",
         X"00000100",
         X"00011100",
         X"00000000",
         X"00000000",
         X"00000000"
      );
      verify_board(exp_board_v);

      wait until clk = '1';
      running     <= '0';
      report "Test finished";
   end process test_proc;

end architecture simulation;

