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
      rd_data_i : in    std_logic_vector(G_COLS-1 downto 0);
      wr_data_o : out   std_logic_vector(G_COLS-1 downto 0);
      wr_en_o   : out   std_logic
   );
end entity life;

architecture structural of life is

   constant C_CELLS : integer                        := G_ROWS * G_COLS;

   subtype  ROW_TYPE   is integer range 0 to G_ROWS - 1;
   subtype  COL_TYPE   is integer range 0 to G_COLS - 1;
   subtype  INDEX_TYPE is integer range 0 to C_CELLS - 1;

   pure function to_index (
      row : ROW_TYPE;
      col : COL_TYPE
   ) return INDEX_TYPE is
   begin
      return row * G_COLS + col;
   end function to_index;

   pure function get_row (
      index : INDEX_TYPE
   ) return ROW_TYPE is
   begin
      return index / G_COLS;
   end function get_row;

   pure function get_col (
      index : INDEX_TYPE
   ) return COL_TYPE is
   begin
      return index rem G_COLS;
   end function get_col;


   type     board_type is array (natural range <>) of std_logic_vector(G_COLS-1 downto 0);
   signal   board : board_type(G_ROWS - 1 downto 0) := (others => (others => '0'));

   subtype  COUNT_TYPE is integer range 0 to 8;
   -- This is the logic of the game:
   -- 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
   -- 2. Any live cell with two or three live neighbours lives on to the next generation.
   -- 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
   -- 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

   pure function new_cell (
      neighbours : COUNT_TYPE;
      cur_cell : std_logic
   ) return std_logic is
      constant C_BIRTH   : std_logic_vector(count_type) := "000100000"; -- The fate of dead cells.
      constant C_SURVIVE : std_logic_vector(count_type) := "001100000"; -- The fate of live cells.
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


   subtype  NEIGHBOURS_TYPE is std_logic_vector(7 downto 0);

   function get_neighbours (
      board_v : board_type;
      index_v : INDEX_TYPE
   ) return NEIGHBOURS_TYPE is
      constant C_N  : integer := -G_COLS;
      constant C_S  : integer := G_COLS;
      constant C_W  : integer := -1;
      constant C_E  : integer := 1;
      constant C_NW : integer := C_N + C_W;
      constant C_NE : integer := C_N + C_E;
      constant C_SW : integer := C_S + C_W;
      constant C_SE : integer := C_S + C_E;

      pure function up (
         index : index_type
      ) return index_type is
      begin
         if get_row(index) = 0 then
            return index + C_N + C_CELLS;
         else
            return index + C_N;
         end if;
      end function up;

      pure function down (
         index : index_type
      ) return index_type is
      begin
         if get_row(index) = G_ROWS - 1 then
            return index + C_S - C_CELLS;
         else
            return index + C_S;
         end if;
      end function down;

      pure function left (
         index : index_type
      ) return index_type is
      begin
         if get_col(index) = 0 then
            return index + C_W + G_COLS;
         else
            return index + C_W;
         end if;
      end function left;

      pure function right (
         index : index_type
      ) return index_type is
      begin
         if get_col(index) = G_COLS - 1 then
            return index + C_E - G_COLS;
         else
            return index + C_E;
         end if;
      end function right;

   --
   begin
      return (
         board_v(up(index_v) / G_COLS)(up(index_v) mod G_COLS),
         board_v(down(index_v) / G_COLS)(down(index_v) mod G_COLS),
         board_v(left(index_v) / G_COLS)(left(index_v) mod G_COLS),
         board_v(right(index_v) / G_COLS)(right(index_v) mod G_COLS),
         board_v(up(right(index_v)) / G_COLS)(up(right(index_v)) mod G_COLS),
         board_v(down(right(index_v)) / G_COLS)(down(right(index_v)) mod G_COLS),
         board_v(up(left(index_v)) / G_COLS)(up(left(index_v)) mod G_COLS),
         board_v(down(left(index_v)) / G_COLS)(down(left(index_v)) mod G_COLS)
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

   type     state_type is (IDLE_ST, READ_FIRST_ST, READ_ST, READ_LAST_ST, UPDATE_ST, WRITE_ST);
   signal   state  : state_type                      := IDLE_ST;
   signal   addr   : std_logic_vector(9 downto 0);
   signal   addr_d : std_logic_vector(9 downto 0);

begin

   ready_o <= '1' when state = IDLE_ST else
              '0';

   -- This holds the actual cells
   board_proc : process (clk_i)
      variable neighbour_count_v : COUNT_TYPE;
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
               board(to_integer(addr_d)) <= rd_data_i(G_COLS-1 downto 0);

               if addr_o = G_ROWS - 1 then
                  state <= READ_LAST_ST;
               else
                  addr_o <= addr_o + 1;
               end if;

            when READ_LAST_ST =>
               board(to_integer(addr_d)) <= rd_data_i(G_COLS-1 downto 0);
               state <= UPDATE_ST;

            when UPDATE_ST =>
               --
               for index in INDEX_TYPE loop
                  neighbour_count_v := count_ones(get_neighbours(board, index));
                  board(index / G_COLS)(index mod G_COLS) <= new_cell(neighbour_count_v,
                  board(index / G_COLS)(index mod G_COLS));
               end loop;

               addr  <= (others => '0');
               state <= WRITE_ST;

            when WRITE_ST =>
               addr_o <= addr;

               wr_data_o(G_COLS-1 downto 0) <= board(to_integer(addr));

               wr_en_o <= '1';
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

