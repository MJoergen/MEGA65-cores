library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

-- This is the logic of the game:
-- 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
-- 2. Any live cell with two or three live neighbours lives on to the next generation.
-- 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
-- 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

-- Performance:
-- The engine is pretty fast, in that it processes a complete row at a time.
-- So the total time needed to process a 160x90 grid is 2*90 = 180 clock cycles,
-- because each row needs to be read one and written once.
-- For larger grids that require external memory (e.g. SDRAM), the limiting factor
-- is the memory bandwidth. The SDRAM has a maximum memory bandwidth of 320 MB/s and a
-- memory capacity of 64 MB.
-- So a 10,000 by 10,000 grid with 3 bits per cell, will use 37.5 MB of memory and will
-- require a memory transfer of 75 MB per generation, which equates to a frame rate of
-- roughly 4 generations per second, assuming the memory bandwidth is the limiting factor.

-- Resource count:
-- This implementation stores three consecutive rows. So in a 160x90 grid, with 3 bits per
-- pixel, each row consists of 160*3 = 480 bits, and the total number of registers (for
-- three rows) is 480*3 = 1440 registers.
-- Larger grids (e.g. 10,000 by 10,000) will require rewriting the engine so it only
-- processes e.g. 100 cells at a given time.

-- The read/write pattern for the BRAM is as follows:
-- * Read row N-1
-- * Read row 0, and also store it in row_first
-- * Read row 1
-- * Write row 0
-- * Read row 2
-- * Write row 1
-- * Read row 3
-- * Write row 2
-- * etc...
-- * Read row N-1
-- * Write row N-2
-- * Read row 0 (not needed, use row_first instead)
-- * Write row N-1

entity life is
   generic (
      G_CELL_BITS : integer;
      G_ROWS      : integer;
      G_COLS      : integer
   );
   port (
      -- Clock, reset, and enable
      clk_i     : in    std_logic;
      rst_i     : in    std_logic;
      ready_o   : out   std_logic;
      step_i    : in    std_logic;

      addr_o    : out   std_logic_vector(9 downto 0);
      rd_data_i : in    std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      wr_data_o : out   std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      wr_en_o   : out   std_logic
   );
end entity life;

architecture structural of life is

   subtype ROW_TYPE   is integer range 0 to G_ROWS - 1;
   subtype COL_TYPE   is integer range 0 to G_COLS - 1;
   subtype COUNT_TYPE is integer range 0 to 8;

   -- Calculate the new state of the cell

   pure function new_cell (
      neighbours : COUNT_TYPE;
      cur_cell   : std_logic_vector
   ) return std_logic_vector is
      -- The fate of dead cells.
      constant C_BIRTH   : std_logic_vector(count_type) := "000100000";
      -- The fate of live cells.
      constant C_SURVIVE : std_logic_vector(count_type) := "001100000";
      variable res_v     : std_logic_vector(G_CELL_BITS - 1 downto 0);
   begin
      assert cur_cell'length = G_CELL_BITS;
      --
      res_v := (others => '0');

      case or (cur_cell) is

         when '1' =>
            if C_SURVIVE(neighbours) = '1' then
               if cur_cell > 1 then
                  res_v := cur_cell - 1;
               else
                  res_v := cur_cell;
               end if;
            else
               res_v := (others => '0');
            end if;

         when others =>
            if C_BIRTH(neighbours) = '1' then
               res_v := (others => '1');
            else
               res_v := (others => '0');
            end if;

      end case;

      return res_v;

   --
   end function new_cell;

   pure function get_cell (
      arg : std_logic_vector;
      col : integer
   ) return std_logic
   is
      variable cell_v : std_logic_vector(G_CELL_BITS - 1 downto 0);
   begin
      cell_v := arg((col + 1) * G_CELL_BITS - 1 downto col * G_CELL_BITS);
      return or (cell_v);
   end function get_cell;


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
         get_cell(prev_v, col_v),
         get_cell(next_v, col_v),
         get_cell(cur_v, prev_col_v),
         get_cell(cur_v, next_col_v),
         get_cell(prev_v, prev_col_v),
         get_cell(prev_v, next_col_v),
         get_cell(next_v, prev_col_v),
         get_cell(next_v, next_col_v)
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
   signal  state     : state_type := IDLE_ST;
   signal  rd_addr   : std_logic_vector(9 downto 0);
   signal  wr_addr   : std_logic_vector(9 downto 0);
   signal  row_first : std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
   signal  row_cur   : std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
   signal  row_next  : std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);

   pure function get_next_row (
      arg : ROW_TYPE
   ) return ROW_TYPE is
   begin
      if arg = G_ROWS - 1 then
         return 0;
      else
         return arg + 1;
      end if;
   end function get_next_row;

   pure function get_prev_row (
      arg : ROW_TYPE
   ) return ROW_TYPE is
   begin
      if arg = 0 then
         return G_ROWS - 1;
      else
         return arg - 1;
      end if;
   end function get_prev_row;

begin

   ready_o <= '1' when state = IDLE_ST else
              '0';

   -- This is a combinatorial process.
   -- This has to be combinatorial, because the write takes place in the same clock cycle
   -- that the read data from the previous clock cycle is available.
   ram_proc : process (all)
      variable neighbour_count_v : COUNT_TYPE;
      variable rd_data_v         : std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      variable cell_v            : std_logic_vector(G_CELL_BITS - 1 downto 0);
   begin
      -- Default values (read from RAM)
      wr_data_o <= (others => '0');
      addr_o    <= rd_addr;
      wr_en_o   <= '0';

      if state = WRITE_ROW_ST then
         rd_data_v := rd_data_i;
         if wr_addr = G_ROWS - 1 then
            rd_data_v := row_first;
         end if;

         for col in 0 to G_COLS - 1 loop
            cell_v                                                          := row_next((col + 1) * G_CELL_BITS - 1 downto col * G_CELL_BITS);
            neighbour_count_v                                               := count_ones(get_neighbours(row_cur, row_next, rd_data_v, col));
            wr_data_o((col + 1) * G_CELL_BITS - 1 downto col * G_CELL_BITS) <= new_cell(neighbour_count_v, cell_v);
         end loop;

         addr_o  <= wr_addr;
         wr_en_o <= '1';
      end if;
   end process ram_proc;

   -- This is the main state machine
   fsm_proc : process (clk_i)
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
               -- Store row 0 for later use
               row_first <= rd_data_i;

               row_cur   <= row_next;
               row_next  <= rd_data_i;
               rd_addr   <= to_stdlogicvector(get_next_row(to_integer(rd_addr)), 10);
               wr_addr   <= to_stdlogicvector(get_prev_row(to_integer(rd_addr)), 10);
               state     <= WRITE_ROW_ST;

            when READ_ROW_NEXT_ST =>
               rd_addr <= to_stdlogicvector(get_next_row(to_integer(rd_addr)), 10);
               wr_addr <= to_stdlogicvector(get_prev_row(to_integer(rd_addr)), 10);
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
            state   <= IDLE_ST;
         end if;
      end if;
   end process fsm_proc;

end architecture structural;

