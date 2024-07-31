library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity controller is
   generic (
      G_NUM_QUEENS : integer
   );
   port (
      clk_i                   : in    std_logic;
      rst_i                   : in    std_logic;
      main_kb_key_pressed_n_i : in    std_logic;
      main_kb_key_num_i       : in    integer range 0 to 79;
      uart_rx_valid_i         : in    std_logic;
      uart_rx_ready_o         : out   std_logic;
      uart_rx_data_i          : in    std_logic_vector(7 downto 0);
      uart_tx_valid_o         : out   std_logic;
      uart_tx_ready_i         : in    std_logic;
      uart_tx_data_o          : out   std_logic_vector(7 downto 0);
      ready_o                 : out   std_logic;
      valid_i                 : in    std_logic;
      result_i                : in    std_logic_vector(G_NUM_QUEENS * G_NUM_QUEENS - 1 downto 0);
      done_i                  : in    std_logic;
      step_o                  : out   std_logic
   );
end entity controller;

architecture synthesis of controller is

   -- MEGA65 key codes that kb_key_num_i is using while
   -- kb_key_pressed_n_i is signalling (low active) which key is pressed
   constant C_M65_INS_DEL     : integer        := 0;
   constant C_M65_RETURN      : integer        := 1;
   constant C_M65_HORZ_CRSR   : integer        := 2;  -- means cursor right in C64 terminology
   constant C_M65_F7          : integer        := 3;
   constant C_M65_F1          : integer        := 4;
   constant C_M65_F3          : integer        := 5;
   constant C_M65_F5          : integer        := 6;
   constant C_M65_VERT_CRSR   : integer        := 7;  -- means cursor down in C64 terminology
   constant C_M65_3           : integer        := 8;
   constant C_M65_W           : integer        := 9;
   constant C_M65_A           : integer        := 10;
   constant C_M65_4           : integer        := 11;
   constant C_M65_Z           : integer        := 12;
   constant C_M65_S           : integer        := 13;
   constant C_M65_E           : integer        := 14;
   constant C_M65_LEFT_SHIFT  : integer        := 15;
   constant C_M65_5           : integer        := 16;
   constant C_M65_R           : integer        := 17;
   constant C_M65_D           : integer        := 18;
   constant C_M65_6           : integer        := 19;
   constant C_M65_C           : integer        := 20;
   constant C_M65_F           : integer        := 21;
   constant C_M65_T           : integer        := 22;
   constant C_M65_X           : integer        := 23;
   constant C_M65_7           : integer        := 24;
   constant C_M65_Y           : integer        := 25;
   constant C_M65_G           : integer        := 26;
   constant C_M65_8           : integer        := 27;
   constant C_M65_B           : integer        := 28;
   constant C_M65_H           : integer        := 29;
   constant C_M65_U           : integer        := 30;
   constant C_M65_V           : integer        := 31;
   constant C_M65_9           : integer        := 32;
   constant C_M65_I           : integer        := 33;
   constant C_M65_J           : integer        := 34;
   constant C_M65_0           : integer        := 35;
   constant C_M65_M           : integer        := 36;
   constant C_M65_K           : integer        := 37;
   constant C_M65_O           : integer        := 38;
   constant C_M65_N           : integer        := 39;
   constant C_M65_PLUS        : integer        := 40;
   constant C_M65_P           : integer        := 41;
   constant C_M65_L           : integer        := 42;
   constant C_M65_MINUS       : integer        := 43;
   constant C_M65_DOT         : integer        := 44;
   constant C_M65_COLON       : integer        := 45;
   constant C_M65_AT          : integer        := 46;
   constant C_M65_COMMA       : integer        := 47;
   constant C_M65_GBP         : integer        := 48;
   constant C_M65_ASTERISK    : integer        := 49;
   constant C_M65_SEMICOLON   : integer        := 50;
   constant C_M65_CLR_HOME    : integer        := 51;
   constant C_M65_RIGHT_SHIFT : integer        := 52;
   constant C_M65_EQUAL       : integer        := 53;
   constant C_M65_ARROW_UP    : integer        := 54; -- symbol, not cursor
   constant C_M65_SLASH       : integer        := 55;
   constant C_M65_1           : integer        := 56;
   constant C_M65_ARROW_LEFT  : integer        := 57; -- symbol, not cursor
   constant C_M65_CTRL        : integer        := 58;
   constant C_M65_2           : integer        := 59;
   constant C_M65_SPACE       : integer        := 60;
   constant C_M65_MEGA        : integer        := 61;
   constant C_M65_Q           : integer        := 62;
   constant C_M65_RUN_STOP    : integer        := 63;
   constant C_M65_NO_SCRL     : integer        := 64;
   constant C_M65_TAB         : integer        := 65;
   constant C_M65_ALT         : integer        := 66;
   constant C_M65_HELP        : integer        := 67;
   constant C_M65_F9          : integer        := 68;
   constant C_M65_F11         : integer        := 69;
   constant C_M65_F13         : integer        := 70;
   constant C_M65_ESC         : integer        := 71;
   constant C_M65_CAPSLOCK    : integer        := 72;
   constant C_M65_UP_CRSR     : integer        := 73; -- cursor up
   constant C_M65_LEFT_CRSR   : integer        := 74; -- cursor left
   constant C_M65_RESTORE     : integer        := 75;
   constant C_M65_NONE        : integer        := 79;

   type     uart_tx_state_type is (IDLE_ST, ROW_ST, EOL_ST, END_ST);
   signal   uart_tx_state : uart_tx_state_type := IDLE_ST;

   signal   row    : natural range 0 to G_NUM_QUEENS - 1;
   signal   result : std_logic_vector(G_NUM_QUEENS * G_NUM_QUEENS - 1 downto 0);

   signal   hex_valid : std_logic;
   signal   hex_ready : std_logic;
   signal   hex_data  : std_logic_vector(G_NUM_QUEENS - 1 downto 0);
   signal   ser_data  : std_logic_vector(8 * G_NUM_QUEENS - 1 downto 0);

   signal   eol_valid : std_logic;
   signal   eol_ready : std_logic;

   signal   uart_tx_hex_valid : std_logic;
   signal   uart_tx_hex_data  : std_logic_vector(7 downto 0);
   signal   uart_tx_eol_valid : std_logic;
   signal   uart_tx_eol_data  : std_logic_vector(7 downto 0);

   signal   result_count : natural range 0 to 1023;

   type     uart_rx_state_type is (IDLE_ST, CONTINUE_ST, END_ST);
   signal   uart_rx_state : uart_rx_state_type := IDLE_ST;

   signal   key_num      : integer range 0 to 79;
   signal   key_pressed  : std_logic;
   signal   key_released : std_logic;

   signal   print : std_logic;

begin

   ready_o <= '1' when uart_tx_state = IDLE_ST else
              '0';

   uart_tx_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         if hex_ready = '1' then
            hex_valid <= '0';
         end if;
         if eol_ready = '1' then
            eol_valid <= '0';
         end if;

         case uart_tx_state is

            when IDLE_ST =>
               if valid_i = '1' or print = '1' then
                  result        <= result_i;
                  row           <= 0;
                  uart_tx_state <= ROW_ST;
                  result_count  <= result_count + 1;
               elsif done_i = '1' then
                  uart_tx_state <= END_ST;
               end if;

            when ROW_ST =>
               if hex_ready = '1' and eol_ready = '1' then
                  hex_data  <= result(G_NUM_QUEENS * (row + 1) - 1 downto G_NUM_QUEENS * row);
                  hex_valid <= '1';
                  if row < G_NUM_QUEENS - 1 then
                     row <= row + 1;
                  else
                     uart_tx_state <= EOL_ST;
                  end if;
               end if;

            when EOL_ST =>
               if hex_ready = '1' and hex_valid = '0' then
                  if eol_valid = '1' then
                     uart_tx_state <= IDLE_ST;
                  else
                     eol_valid <= '1';
                  end if;
               end if;

            when END_ST =>
               null;

         end case;

         if rst_i = '1' then
            result_count  <= 0;
            uart_tx_state <= IDLE_ST;
         end if;
      end if;
   end process uart_tx_proc;

   stringifier_inst : entity work.stringifier
      generic map (
         G_DATA_BITS => G_NUM_QUEENS
      )
      port map (
         s_data_i => hex_data,
         m_data_o => ser_data
      ); -- stringifier_inst

   serializer_hex_inst : entity work.serializer
      generic map (
         G_DATA_SIZE_IN  => 8 * G_NUM_QUEENS + 16,
         G_DATA_SIZE_OUT => 8
      )
      port map (
         clk_i     => clk_i,
         rst_i     => rst_i,
         s_valid_i => hex_valid,
         s_ready_o => hex_ready,
         s_data_i  => ser_data & X"0D0A",
         m_valid_o => uart_tx_hex_valid,
         m_ready_i => uart_tx_ready_i,
         m_data_o  => uart_tx_hex_data
      ); -- serializer_hex_inst

   serializer_eol_inst : entity work.serializer
      generic map (
         G_DATA_SIZE_IN  => 16,
         G_DATA_SIZE_OUT => 8
      )
      port map (
         clk_i     => clk_i,
         rst_i     => rst_i,
         s_valid_i => eol_valid,
         s_ready_o => eol_ready,
         s_data_i  => X"0D0A",
         m_valid_o => uart_tx_eol_valid,
         m_ready_i => uart_tx_ready_i,
         m_data_o  => uart_tx_eol_data
      ); -- serializer_eol_inst

   uart_tx_valid_o <= uart_tx_hex_valid or uart_tx_eol_valid;
   uart_tx_data_o  <= uart_tx_hex_data  or uart_tx_eol_data;


   uart_rx_ready_o <= '1' when uart_rx_state = IDLE_ST else
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

   uart_rx_proc : process (clk_i)
   begin
      if rising_edge(clk_i) then
         step_o <= '0';
         print  <= '0';

         case uart_rx_state is

            when IDLE_ST =>
               if uart_rx_valid_i = '1' then

                  case uart_rx_data_i is

                     when X"50" | X"70" =>            -- 'P'
                        print <= '1';

                     when X"53" | X"73" =>            -- 'S'
                        step_o <= '1';

                     when X"43" | X"63" =>            -- 'C'
                        step_o        <= '1';
                        uart_rx_state <= CONTINUE_ST;

                     when X"45" | X"65" =>            -- 'E'
                        step_o        <= '1';
                        uart_rx_state <= END_ST;

                     when others =>
                        null;

                  end case;

               end if;

               if key_pressed = '1' then

                  case key_num is

                     when C_M65_P =>
                        print <= '1';

                     when C_M65_S =>
                        step_o <= '1';

                     when C_M65_C =>
                        step_o        <= '1';
                        uart_rx_state <= CONTINUE_ST;

                     when C_M65_E =>
                        step_o        <= '1';
                        uart_rx_state <= END_ST;

                     when others =>
                        null;

                  end case;

               end if;

            when CONTINUE_ST =>
               if valid_i = '1' then
                  uart_rx_state <= IDLE_ST;
               else
                  step_o <= '1';
               end if;

            when END_ST =>
               step_o <= '1';

         end case;

         if rst_i = '1' then
            uart_rx_state <= IDLE_ST;
         end if;
      end if;
   end process uart_rx_proc;

end architecture synthesis;

