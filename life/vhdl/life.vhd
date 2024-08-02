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

   type    state_type is (
      IDLE_ST, READ_ROW_LAST_ST, READ_ROW_0_ST, READ_ROW_1_ST,
      READ_ROW_NEXT_ST, WRITE_ROW_ST
   );
   signal  state    : state_type := IDLE_ST;
   signal  rd_addr  : std_logic_vector(9 downto 0);
   signal  wr_addr  : std_logic_vector(9 downto 0);
   signal  row_last : std_logic_vector(G_COLS - 1 downto 0);
   signal  row_cur  : std_logic_vector(G_COLS - 1 downto 0);
   signal  row_next : std_logic_vector(G_COLS - 1 downto 0);

-- * Read row N-1
-- * Read row 0
-- * Read row 1
-- * Write row 0
-- * Read row 2
-- * Write row 1
-- * Read row 3
-- * Write row 2
-- * etc...
-- * Read row N-1
-- * Write row N-2
-- * Write row N-1

begin

   ready_o <= '1' when state = IDLE_ST else
              '0';

   -- This is a combinatorial process
   ram_proc : process (all)
      variable neighbour_count_v : COUNT_TYPE;
      variable rd_data_v         : std_logic_vector(G_COLS - 1 downto 0);
   begin
      -- Default values (read from RAM)
      wr_data_o <= (others => '0');
      addr_o    <= rd_addr;
      wr_en_o   <= '0';

      if state = WRITE_ROW_ST then
         rd_data_v := rd_data_i;
         if wr_addr = G_ROWS - 1 then
            rd_data_v := row_last;
         end if;

         for col in 0 to G_COLS - 1 loop
            neighbour_count_v := count_ones(get_neighbours(row_cur, row_next, rd_data_v, col));
            wr_data_o(col)    <= new_cell(neighbour_count_v, row_next(col));
         end loop;

         addr_o  <= wr_addr;
         wr_en_o <= '1';
      end if;
   end process ram_proc;

   -- This holds the actual cells
   board_proc : process (clk_i)
      variable prev_row_v : ROW_TYPE; -- previous row index
      variable next_row_v : ROW_TYPE; -- next row index
   begin
      if rising_edge(clk_i) then

         case state is

            when IDLE_ST =>
               if step_i = '1' then
                  rd_addr <= to_stdlogicvector(G_ROWS - 1, 10);
                  state   <= READ_ROW_LAST_ST;
               end if;

            when READ_ROW_LAST_ST =>
               rd_addr <= to_stdlogicvector(0, 10);
               state   <= READ_ROW_0_ST;

            when READ_ROW_0_ST =>
               row_next <= rd_data_i;
               rd_addr  <= to_stdlogicvector(1, 10);
               state    <= READ_ROW_1_ST;

            when READ_ROW_1_ST =>
               row_cur  <= row_next;
               row_next <= rd_data_i;
               row_last <= rd_data_i;
               rd_addr  <= to_stdlogicvector(2, 10);
               wr_addr  <= to_stdlogicvector(0, 10);
               state    <= WRITE_ROW_ST;

            when READ_ROW_NEXT_ST =>
               rd_addr <= to_stdlogicvector((to_integer(rd_addr) + 1) mod G_ROWS, 10);
               wr_addr <= to_stdlogicvector((to_integer(rd_addr) - 1) mod G_ROWS, 10);
               state   <= WRITE_ROW_ST;

            when WRITE_ROW_ST =>
               row_cur  <= row_next;
               row_next <= rd_data_i;
               if wr_addr = G_ROWS - 1 then
                  state <= IDLE_ST;
               else
                  state <= READ_ROW_NEXT_ST;
               end if;

         end case;

         if rst_i = '1' then
            rd_addr <= (others => '0');
            wr_addr <= (others => '0');
         end if;
      end if;
   end process board_proc;

end architecture structural;

