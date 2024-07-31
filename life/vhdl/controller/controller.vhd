library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity controller is
   generic (
      G_ROWS : integer;
      G_COLS : integer
   );
   port (
      clk_i                   : in    std_logic;
      rst_i                   : in    std_logic;
      main_kb_key_num_i       : in    integer range 0 to 79;
      main_kb_key_pressed_n_i : in    std_logic;
      uart_rx_valid_i         : in    std_logic;
      uart_rx_ready_o         : out   std_logic;
      uart_rx_data_i          : in    std_logic_vector(7 downto 0);
      uart_tx_valid_o         : out   std_logic;
      uart_tx_ready_i         : in    std_logic;
      uart_tx_data_o          : out   std_logic_vector(7 downto 0);
      board_i                 : in    std_logic_vector(G_ROWS * G_COLS - 1 downto 0);
      step_o                  : out   std_logic;
      wr_index_o              : out   integer range G_ROWS * G_COLS - 1 downto 0;
      wr_value_o              : out   std_logic;
      wr_en_o                 : out   std_logic
   );
end entity controller;

architecture synthesis of controller is

   -- MEGA65 key codes that kb_key_num_i is using while
   -- kb_key_pressed_n_i is signalling (low active) which key is pressed
   constant C_M65_INS_DEL     : integer  := 0;
   constant C_M65_RETURN      : integer  := 1;
   constant C_M65_HORZ_CRSR   : integer  := 2;  -- means cursor right in C64 terminology
   constant C_M65_F7          : integer  := 3;
   constant C_M65_F1          : integer  := 4;
   constant C_M65_F3          : integer  := 5;
   constant C_M65_F5          : integer  := 6;
   constant C_M65_VERT_CRSR   : integer  := 7;  -- means cursor down in C64 terminology
   constant C_M65_3           : integer  := 8;
   constant C_M65_W           : integer  := 9;
   constant C_M65_A           : integer  := 10;
   constant C_M65_4           : integer  := 11;
   constant C_M65_Z           : integer  := 12;
   constant C_M65_S           : integer  := 13;
   constant C_M65_E           : integer  := 14;
   constant C_M65_LEFT_SHIFT  : integer  := 15;
   constant C_M65_5           : integer  := 16;
   constant C_M65_R           : integer  := 17;
   constant C_M65_D           : integer  := 18;
   constant C_M65_6           : integer  := 19;
   constant C_M65_C           : integer  := 20;
   constant C_M65_F           : integer  := 21;
   constant C_M65_T           : integer  := 22;
   constant C_M65_X           : integer  := 23;
   constant C_M65_7           : integer  := 24;
   constant C_M65_Y           : integer  := 25;
   constant C_M65_G           : integer  := 26;
   constant C_M65_8           : integer  := 27;
   constant C_M65_B           : integer  := 28;
   constant C_M65_H           : integer  := 29;
   constant C_M65_U           : integer  := 30;
   constant C_M65_V           : integer  := 31;
   constant C_M65_9           : integer  := 32;
   constant C_M65_I           : integer  := 33;
   constant C_M65_J           : integer  := 34;
   constant C_M65_0           : integer  := 35;
   constant C_M65_M           : integer  := 36;
   constant C_M65_K           : integer  := 37;
   constant C_M65_O           : integer  := 38;
   constant C_M65_N           : integer  := 39;
   constant C_M65_PLUS        : integer  := 40;
   constant C_M65_P           : integer  := 41;
   constant C_M65_L           : integer  := 42;
   constant C_M65_MINUS       : integer  := 43;
   constant C_M65_DOT         : integer  := 44;
   constant C_M65_COLON       : integer  := 45;
   constant C_M65_AT          : integer  := 46;
   constant C_M65_COMMA       : integer  := 47;
   constant C_M65_GBP         : integer  := 48;
   constant C_M65_ASTERISK    : integer  := 49;
   constant C_M65_SEMICOLON   : integer  := 50;
   constant C_M65_CLR_HOME    : integer  := 51;
   constant C_M65_RIGHT_SHIFT : integer  := 52;
   constant C_M65_EQUAL       : integer  := 53;
   constant C_M65_ARROW_UP    : integer  := 54; -- symbol, not cursor
   constant C_M65_SLASH       : integer  := 55;
   constant C_M65_1           : integer  := 56;
   constant C_M65_ARROW_LEFT  : integer  := 57; -- symbol, not cursor
   constant C_M65_CTRL        : integer  := 58;
   constant C_M65_2           : integer  := 59;
   constant C_M65_SPACE       : integer  := 60;
   constant C_M65_MEGA        : integer  := 61;
   constant C_M65_Q           : integer  := 62;
   constant C_M65_RUN_STOP    : integer  := 63;
   constant C_M65_NO_SCRL     : integer  := 64;
   constant C_M65_TAB         : integer  := 65;
   constant C_M65_ALT         : integer  := 66;
   constant C_M65_HELP        : integer  := 67;
   constant C_M65_F9          : integer  := 68;
   constant C_M65_F11         : integer  := 69;
   constant C_M65_F13         : integer  := 70;
   constant C_M65_ESC         : integer  := 71;
   constant C_M65_CAPSLOCK    : integer  := 72;
   constant C_M65_UP_CRSR     : integer  := 73; -- cursor up
   constant C_M65_LEFT_CRSR   : integer  := 74; -- cursor left
   constant C_M65_RESTORE     : integer  := 75;
   constant C_M65_NONE        : integer  := 79;

   type     init_state_type is (INIT_ST, DONE_ST);
   signal   init_state : init_state_type := INIT_ST;

   type     state_type is (IDLE_ST, CONTINUOUS_ST, PRINTING_ST);
   signal   state : state_type           := IDLE_ST;

   signal   cur_col : natural range 0 to G_COLS + 1;
   signal   cur_row : natural range 0 to G_ROWS;

   signal   lfsr_output : std_logic_vector(31 downto 0);

   signal   key_num      : integer range 0 to 79;
   signal   key_pressed  : std_logic;
   signal   key_released : std_logic;

   signal   step_counter : std_logic_vector(23 downto 0) := (others => '0');

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


   init_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then

         case init_state is

            when INIT_ST =>
               if wr_index_o = G_ROWS * G_COLS - 1 then
                  init_state <= DONE_ST;
               else
                  wr_index_o <= wr_index_o + 1;
                  wr_value_o <= and(lfsr_output(1 downto 0));
                  wr_en_o    <= '1';
               end if;

            when DONE_ST =>
               wr_index_o <= 0;
               wr_value_o <= '0';
               wr_en_o    <= '0';

               if (uart_rx_valid_i = '1' and (uart_rx_data_i = X"49" or uart_rx_data_i = X"69")) or
                  (main_kb_key_pressed_n_i = '0' and main_kb_key_num_i = C_M65_I) then
                  init_state <= INIT_ST;
               end if;


         end case;

         if rst_i = '1' then
            wr_index_o <= 0;
            wr_value_o <= '0';
            wr_en_o    <= '0';
            init_state <= INIT_ST;
         end if;
      end if;
   end process init_proc;

   uart_rx_ready_o <= '1' when state = IDLE_ST else
                      '0';

   key_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         key_pressed <= '0';

         if main_kb_key_pressed_n_i = '0' then
            if key_num /= main_kb_key_num_i or key_released = '1' then
               key_num      <= main_kb_key_num_i;
               key_pressed  <= '1';
               key_released <= '0';
            end if;
         end if;

         if main_kb_key_pressed_n_i = '1' then
            if key_num = main_kb_key_num_i then
               key_released <= '1';
            end if;
         end if;

         if rst_i = '1' then
            key_pressed  <= '0';
            key_released <= '1';
            key_num      <= C_M65_NONE;
         end if;
      end if;
   end process key_proc;

   fsm_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         step_counter <= step_counter + 1;

         step_o       <= '0';
         if uart_tx_ready_i = '1' then
            uart_tx_valid_o <= '0';
         end if;

         case state is

            when IDLE_ST =>
               if uart_rx_valid_i = '1' then

                  case uart_rx_data_i is

                     when X"53" | X"73" =>                                                   -- "S"
                        step_o <= '1';

                     when X"50" | X"70" =>                                                   -- "P"
                        cur_col <= 0;
                        cur_row <= 0;
                        state   <= PRINTING_ST;

                     when others =>
                        null;

                  end case;

               end if;

               if key_pressed = '1' then

                  case key_num is

                     when C_M65_P =>
                        cur_col <= 0;
                        cur_row <= 0;
                        state   <= PRINTING_ST;

                     when C_M65_S =>
                        step_o <= '1';

                     when C_M65_C =>
                        state <= CONTINUOUS_ST;

                     when others =>
                        null;

                  end case;

               end if;

            when CONTINUOUS_ST =>
               step_o <= and(step_counter);

               if key_pressed = '1' then
                  state <= IDLE_ST;
               end if;

            when PRINTING_ST =>
               if uart_tx_ready_i = '1' then
                  if cur_col < G_COLS and cur_row < G_ROWS then
                     if board_i(G_COLS * G_ROWS - 1 - G_COLS * cur_row - cur_col) = '1' then
                        uart_tx_data_o <= X"58";                                             -- "X"
                     else
                        uart_tx_data_o <= X"2E";                                             -- "."
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
            state <= IDLE_ST;
         end if;
      end if;
   end process fsm_proc;

end architecture synthesis;

