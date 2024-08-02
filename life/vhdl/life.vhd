library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity life is
   generic (
      G_ROWS : integer;
      G_COLS : integer
   );
   port (
      -- Clock, reset, and enable
      clk_i     : in    std_logic;
      rst_i     : in    std_logic;
      ready_o   : out   std_logic;
      step_i    : in    std_logic;

      addr_o    : out   std_logic_vector(9 downto 0);
      rd_data_i : in    std_logic_vector(G_COLS - 1 downto 0);
      wr_data_o : out   std_logic_vector(G_COLS - 1 downto 0);
      wr_en_o   : out   std_logic
   );
end entity life;

architecture structural of life is

   subtype ROW_TYPE   is integer range 0 to G_ROWS - 1;
   subtype COL_TYPE   is integer range 0 to G_COLS - 1;

   type    board_type is array (natural range <>) of std_logic_vector(G_COLS - 1 downto 0);
   signal  board : board_type(G_ROWS - 1 downto 0) := (others => (others => '0'));

   -- This is the logic of the game:
   -- 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
   -- 2. Any live cell with two or three live neighbours lives on to the next generation.
   -- 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
   -- 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

   subtype COUNT_TYPE is integer range 0 to 8;

   pure function new_cell (
      neighbours : COUNT_TYPE;
      cur_cell   : std_logic
   ) return std_logic is
      -- The fate of dead cells.
      constant C_BIRTH   : std_logic_vector(count_type) := "000100000";
      -- The fate of live cells.
      constant C_SURVIVE : std_logic_vector(count_type) := "001100000";
   begin
      --
      case cur_cell is

         when '1' =>
            return C_SURVIVE(neighbours);

         when others =>
            return C_BIRTH(neighbours);

      end case;

      return '0';
   end function new_cell;


   -- Return the eight neighbours
   function get_neighbours (
      prev_v : std_logic_vector; -- previous row
      cur_v  : std_logic_vector; -- current row
      next_v : std_logic_vector; -- next row
      col_v  : COL_TYPE          -- current column index
   ) return std_logic_vector is
      variable next_col_v : COL_TYPE;
      variable prev_col_v : COL_TYPE;
   --
   begin
      next_col_v := (col_v + 1) mod G_COLS;
      prev_col_v := (col_v - 1) mod G_COLS;
      return (
         prev_v(col_v),
         next_v(col_v),
         cur_v(prev_col_v),
         cur_v(next_col_v),
         prev_v(prev_col_v),
         prev_v(next_col_v),
         next_v(prev_col_v),
         next_v(next_col_v)
      );
   end function get_neighbours;

   pure function count_ones (
      input : std_logic_vector(7 downto 0)
   ) return COUNT_TYPE is
      --
      type     count_ones_type is array (0 to 15) of count_type;
      constant C_COUNT_ONES_4 : count_ones_type := (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4);
   begin
      return C_COUNT_ONES_4(to_integer(input(3 downto 0))) + C_COUNT_ONES_4(to_integer(input(7 downto 4)));
   end function count_ones;

   type    state_type is (IDLE_ST, READ_FIRST_ST, READ_ST, READ_LAST_ST, UPDATE_ST, WRITE_ST);
   signal  state  : state_type                     := IDLE_ST;
   signal  addr   : std_logic_vector(9 downto 0);
   signal  addr_d : std_logic_vector(9 downto 0);

begin

   ready_o <= '1' when state = IDLE_ST else
              '0';

   -- This holds the actual cells
   board_proc : process (clk_i)
      variable neighbour_count_v : COUNT_TYPE;
      variable prev_row_v        : ROW_TYPE; -- previous row index
      variable next_row_v        : ROW_TYPE; -- next row index
   begin
      if rising_edge(clk_i) then
         addr_d  <= addr_o;
         wr_en_o <= '0';

         case state is

            when IDLE_ST =>
               if step_i = '1' then
                  addr_o <= (others => '0');
                  state  <= READ_FIRST_ST;
               end if;

            when READ_FIRST_ST =>
               addr_o <= addr_o + 1;
               state  <= READ_ST;

            when READ_ST =>
               board(to_integer(addr_d)) <= rd_data_i(G_COLS - 1 downto 0);

               if addr_o = G_ROWS - 1 then
                  state <= READ_LAST_ST;
               else
                  addr_o <= addr_o + 1;
               end if;

            when READ_LAST_ST =>
               board(to_integer(addr_d)) <= rd_data_i(G_COLS - 1 downto 0);
               state                     <= UPDATE_ST;

            when UPDATE_ST =>
               --
               for row in 0 to G_ROWS - 1 loop
                  prev_row_v := (row - 1) mod G_ROWS;
                  next_row_v := (row + 1) mod G_ROWS;

                  for col in 0 to G_COLS - 1 loop
                     neighbour_count_v := count_ones(get_neighbours(board(prev_row_v), board(row), board(next_row_v), col));
                     board(row)(col)   <= new_cell(neighbour_count_v, board(row)(col));
                  end loop;

               --
               end loop;

               addr  <= (others => '0');
               state <= WRITE_ST;

            when WRITE_ST =>
               addr_o                         <= addr;

               wr_data_o(G_COLS - 1 downto 0) <= board(to_integer(addr));

               wr_en_o                        <= '1';
               if addr = G_ROWS - 1 then
                  state <= IDLE_ST;
               else
                  addr <= addr + 1;
               end if;

         end case;

         if rst_i = '1' then
            wr_data_o <= (others => '0');
            addr_o    <= (others => '0');
         end if;
      end if;
   end process board_proc;

end architecture structural;

