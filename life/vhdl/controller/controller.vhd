library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity controller is
   generic (
      G_CELL_BITS : integer;
      G_ROWS      : integer;
      G_COLS      : integer
   );
   port (
      clk_i                : in    std_logic;
      rst_i                : in    std_logic;
      cmd_valid_i          : in    std_logic;
      cmd_ready_o          : out   std_logic;
      cmd_data_i           : in    std_logic_vector(7 downto 0);
      uart_tx_valid_o      : out   std_logic;
      uart_tx_ready_i      : in    std_logic;
      uart_tx_data_o       : out   std_logic_vector(7 downto 0);
      init_density_i       : in    natural range 0 to 100;
      generational_speed_i : in    natural range 0 to 31;
      ready_i              : in    std_logic;
      step_o               : out   std_logic;
      count_o              : out   std_logic_vector(15 downto 0);
      board_busy_o         : out   std_logic;
      board_addr_o         : out   std_logic_vector(9 downto 0);
      board_rd_data_i      : in    std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      board_wr_data_o      : out   std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      board_wr_en_o        : out   std_logic
   );
end entity controller;

architecture synthesis of controller is

   constant C_POPULATION_RATE : natural                  := 25; -- Initial population rate in %

   type     state_type is (INIT_ST, IDLE_ST, CONTINUOUS_ST, PRINTING_ST);
   signal   state : state_type                           := INIT_ST;

   signal   cur_col      : natural range 0 to G_COLS + 1;
   signal   cur_row      : natural range 0 to G_ROWS;
   signal   wait_for_ram : std_logic;

   signal   rand_output       : std_logic_vector(127 downto 0);
   signal   rand7             : std_logic_vector(6 downto 0);
   signal   init_rand7_cutoff : std_logic_vector(6 downto 0);

   signal   step_counter : std_logic_vector(31 downto 0) := (others => '0');
   signal   step         : std_logic;

   pure function to_stdlogic (
      arg : boolean
   ) return std_logic is
   begin
      if arg then
         return '1';
      else
         return '0';
      end if;
   end function to_stdlogic;

begin

   step_proc : process (all)
      variable tmp_v : std_logic_vector(31 downto 0);
   begin
      tmp_v                                := (others => '1');
      tmp_v(generational_speed_i downto 0) := step_counter(generational_speed_i downto 0);
      step <= and(tmp_v);
   end process step_proc;

   random_inst : entity work.random
      port map (
         clk_i    => clk_i,
         rst_i    => rst_i,
         update_i => '1',
         output_o => rand_output
      ); -- random_inst

   -- Select seven widely (but unevenly) spaced bits from the random output
   rand7        <= rand_output(20) & rand_output(27) & rand_output(11) & rand_output(17) &
                   rand_output(0) & rand_output(25) & rand_output(7);


   board_busy_o <= '1' when state = PRINTING_ST or board_wr_en_o = '1' else
                   '0';
   board_addr_o <= to_stdlogicvector(cur_row, 10);

   cmd_ready_o  <= '1' when state = IDLE_ST and ready_i = '1' else
                   '0';

   fsm_proc : process (clk_i)
      variable cell_v : std_logic_vector(G_CELL_BITS - 1 downto 0);
   begin
      if rising_edge(clk_i) then
         board_wr_en_o     <= '0';
         step_counter      <= step_counter + 1;
         init_rand7_cutoff <= to_stdlogicvector((init_density_i * 128) / 100, 7);

         if ready_i = '1' then
            step_o <= '0';
         end if;
         if uart_tx_ready_i = '1' then
            uart_tx_valid_o <= '0';
         end if;

         case state is

            when INIT_ST =>
               if board_wr_en_o = '1' then
                  if cur_row < G_ROWS - 1 then
                     cur_row <= cur_row + 1;
                  else
                     state <= IDLE_ST;
                  end if;
               end if;

               cell_v                                                                        := (others => to_stdlogic(rand7 < init_rand7_cutoff));
               board_wr_data_o((cur_col + 1) * G_CELL_BITS - 1 downto cur_col * G_CELL_BITS) <= cell_v;
               if cur_col < G_COLS - 1 then
                  cur_col <= cur_col + 1;
               else
                  cur_col       <= 0;
                  board_wr_en_o <= '1';
               end if;

            when IDLE_ST =>
               if cmd_valid_i = '1' then

                  case cmd_data_i is

                     when X"43" =>
                        -- "C"
                        state <= CONTINUOUS_ST;

                     when X"49" =>
                        -- "I"
                        cur_col <= 0;
                        cur_row <= 0;
                        count_o <= (others => '0');
                        state   <= INIT_ST;

                     when X"50" =>
                        -- "P"
                        cur_col      <= 0;
                        cur_row      <= 0;
                        wait_for_ram <= '1';
                        state        <= PRINTING_ST;

                     when X"53" =>
                        -- "S"
                        step_o  <= '1';
                        count_o <= count_o + 1;

                     when others =>
                        null;

                  end case;

               end if;

            when CONTINUOUS_ST =>
               step_o <= step;
               if step = '1' then
                  count_o <= count_o + 1;
               end if;

               if cmd_valid_i = '1' then
                  state <= IDLE_ST;
               end if;

            when PRINTING_ST =>
               wait_for_ram <= '0';
               if uart_tx_ready_i = '1' and wait_for_ram = '0' then
                  if cur_col < G_COLS and cur_row < G_ROWS then
                     cell_v := board_rd_data_i((cur_col + 1) * G_CELL_BITS - 1 downto cur_col * G_CELL_BITS);
                     if cell_v = 0 then
                        uart_tx_data_o <= X"2E";
                     else
                        uart_tx_data_o <= X"30" + cell_v;
                     end if;
                  else
                     if cur_col = G_COLS then
                        uart_tx_data_o <= X"0D";
                     else
                        uart_tx_data_o <= X"0A";
                     end if;
                  end if;
                  uart_tx_valid_o <= '1';

                  if cur_col < G_COLS + 1 and cur_row < G_ROWS then
                     cur_col      <= cur_col + 1;
                     wait_for_ram <= '1';
                  else
                     cur_col <= 0;
                     if cur_row < G_ROWS then
                        cur_row <= cur_row + 1;
                     else
                        state <= IDLE_ST;
                     end if;
                  end if;
               end if;

         end case;

         if rst_i = '1' then
            cur_row <= 0;
            cur_col <= 0;
            state   <= INIT_ST;
            count_o <= (others => '0');
         end if;
      end if;
   end process fsm_proc;

end architecture synthesis;

