library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity controller is
   generic (
      G_ROWS : integer;
      G_COLS : integer
   );
   port (
      clk_i           : in    std_logic;
      rst_i           : in    std_logic;
      cmd_valid_i     : in    std_logic;
      cmd_ready_o     : out   std_logic;
      cmd_data_i      : in    std_logic_vector(7 downto 0);
      uart_tx_valid_o : out   std_logic;
      uart_tx_ready_i : in    std_logic;
      uart_tx_data_o  : out   std_logic_vector(7 downto 0);
      ready_i         : in    std_logic;
      step_o          : out   std_logic;
      board_busy_o    : out   std_logic;
      board_addr_o    : out   std_logic_vector(9 downto 0);
      board_rd_data_i : in    std_logic_vector(G_COLS - 1 downto 0);
      board_wr_data_o : out   std_logic_vector(G_COLS - 1 downto 0);
      board_wr_en_o   : out   std_logic
   );
end entity controller;

architecture synthesis of controller is

   constant C_POPULATION_RATE : natural                  := 25; -- Initial population rate in %

   type     state_type is (INIT_ST, IDLE_ST, CONTINUOUS_ST, PRINTING_ST);
   signal   state : state_type                           := INIT_ST;

   signal   cur_col : natural range 0 to G_COLS + 1;
   signal   cur_row : natural range 0 to G_ROWS;

   signal   lfsr_output : std_logic_vector(31 downto 0);
   signal   rand7       : std_logic_vector(6 downto 0);

   signal   step_counter : std_logic_vector(23 downto 0) := (others => '0');

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

   lfsr_inst : entity work.lfsr
      generic map (
         G_TAPS  => X"0000000080000EA6", -- see https://users.ece.cmu.edu/~koopman/lfsr/32.txt
         G_WIDTH => 32
      )
      port map (
         clk_i      => clk_i,
         rst_i      => rst_i,
         update_i   => '1',
         load_i     => '0',
         load_val_i => (others => '0'),
         output_o   => lfsr_output
      ); -- lfsr_inst

   -- Select seven widely (but unevenly) spaced bits from the LFSR output
   rand7           <= lfsr_output(20) & lfsr_output(27) & lfsr_output(11) & lfsr_output(17) &
                      lfsr_output(0) & lfsr_output(25) & lfsr_output(7);


   board_busy_o    <= '1' when state = PRINTING_ST or board_wr_en_o = '1' else
                      '0';
   board_addr_o    <= to_stdlogicvector(cur_row, 10);

   cmd_ready_o <= '1' when state = IDLE_ST and ready_i = '1' else
                  '0';

   fsm_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         board_wr_en_o <= '0';
         step_counter  <= step_counter + 1;

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

               board_wr_data_o(cur_col) <= to_stdlogic(rand7 < (C_POPULATION_RATE * 128) / 100);
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
                        state   <= INIT_ST;

                     when X"50" =>
                        -- "P"
                        cur_col <= 0;
                        cur_row <= 0;
                        state   <= PRINTING_ST;

                     when X"53" =>
                        -- "S"
                        step_o <= '1';

                     when others =>
                        null;

                  end case;

               end if;

            when CONTINUOUS_ST =>
               step_o <= and(step_counter);

               if cmd_valid_i = '1' then
                  state <= IDLE_ST;
               end if;

            when PRINTING_ST =>
               if uart_tx_ready_i = '1' then
                  if cur_col < G_COLS and cur_row < G_ROWS then
                     if board_rd_data_i(cur_col) = '1' then
                        -- "X"
                        uart_tx_data_o <= X"58";
                     else
                        -- "."
                        uart_tx_data_o <= X"2E";
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
                     cur_col <= cur_col + 1;
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
         end if;
      end if;
   end process fsm_proc;

end architecture synthesis;

