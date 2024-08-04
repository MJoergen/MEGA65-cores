----------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework
--
-- MEGA65 main file that contains the whole machine
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
----------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity controller_wrapper is
   generic (
      G_MAIN_CLK_HZ   : natural;
      G_UART_BAUDRATE : natural;
      G_CELL_BITS     : natural;
      G_ROWS          : integer;
      G_COLS          : integer
   );
   port (
      main_clk_i                : in    std_logic;
      main_rst_i                : in    std_logic;
      main_kb_key_num_i         : in    integer range 0 to 79;
      main_kb_key_pressed_n_i   : in    std_logic;
      uart_tx_o                 : out   std_logic;
      uart_rx_i                 : in    std_logic;
      main_init_density_i       : in    natural range 0 to 100;
      main_generational_speed_i : in    natural range 0 to 31;
      main_life_ready_i         : in    std_logic;
      main_life_step_o          : out   std_logic;
      main_life_gens_o          : out   std_logic_vector(15 downto 0);
      main_board_busy_o         : out   std_logic;
      main_board_addr_o         : out   std_logic_vector(9 downto 0);
      main_board_rd_data_i      : in    std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      main_board_wr_data_o      : out   std_logic_vector(G_CELL_BITS * G_COLS - 1 downto 0);
      main_board_wr_en_o        : out   std_logic
   );
end entity controller_wrapper;

architecture synthesis of controller_wrapper is

   -- MEGA65 key codes that kb_key_num_i is using while
   -- kb_key_pressed_n_i is signalling (low active) which key is pressed
   constant C_M65_INS_DEL     : integer := 0;
   constant C_M65_RETURN      : integer := 1;
   constant C_M65_HORZ_CRSR   : integer := 2;  -- means cursor right in C64 terminology
   constant C_M65_F7          : integer := 3;
   constant C_M65_F1          : integer := 4;
   constant C_M65_F3          : integer := 5;
   constant C_M65_F5          : integer := 6;
   constant C_M65_VERT_CRSR   : integer := 7;  -- means cursor down in C64 terminology
   constant C_M65_3           : integer := 8;
   constant C_M65_W           : integer := 9;
   constant C_M65_A           : integer := 10;
   constant C_M65_4           : integer := 11;
   constant C_M65_Z           : integer := 12;
   constant C_M65_S           : integer := 13;
   constant C_M65_E           : integer := 14;
   constant C_M65_LEFT_SHIFT  : integer := 15;
   constant C_M65_5           : integer := 16;
   constant C_M65_R           : integer := 17;
   constant C_M65_D           : integer := 18;
   constant C_M65_6           : integer := 19;
   constant C_M65_C           : integer := 20;
   constant C_M65_F           : integer := 21;
   constant C_M65_T           : integer := 22;
   constant C_M65_X           : integer := 23;
   constant C_M65_7           : integer := 24;
   constant C_M65_Y           : integer := 25;
   constant C_M65_G           : integer := 26;
   constant C_M65_8           : integer := 27;
   constant C_M65_B           : integer := 28;
   constant C_M65_H           : integer := 29;
   constant C_M65_U           : integer := 30;
   constant C_M65_V           : integer := 31;
   constant C_M65_9           : integer := 32;
   constant C_M65_I           : integer := 33;
   constant C_M65_J           : integer := 34;
   constant C_M65_0           : integer := 35;
   constant C_M65_M           : integer := 36;
   constant C_M65_K           : integer := 37;
   constant C_M65_O           : integer := 38;
   constant C_M65_N           : integer := 39;
   constant C_M65_PLUS        : integer := 40;
   constant C_M65_P           : integer := 41;
   constant C_M65_L           : integer := 42;
   constant C_M65_MINUS       : integer := 43;
   constant C_M65_DOT         : integer := 44;
   constant C_M65_COLON       : integer := 45;
   constant C_M65_AT          : integer := 46;
   constant C_M65_COMMA       : integer := 47;
   constant C_M65_GBP         : integer := 48;
   constant C_M65_ASTERISK    : integer := 49;
   constant C_M65_SEMICOLON   : integer := 50;
   constant C_M65_CLR_HOME    : integer := 51;
   constant C_M65_RIGHT_SHIFT : integer := 52;
   constant C_M65_EQUAL       : integer := 53;
   constant C_M65_ARROW_UP    : integer := 54; -- symbol, not cursor
   constant C_M65_SLASH       : integer := 55;
   constant C_M65_1           : integer := 56;
   constant C_M65_ARROW_LEFT  : integer := 57; -- symbol, not cursor
   constant C_M65_CTRL        : integer := 58;
   constant C_M65_2           : integer := 59;
   constant C_M65_SPACE       : integer := 60;
   constant C_M65_MEGA        : integer := 61;
   constant C_M65_Q           : integer := 62;
   constant C_M65_RUN_STOP    : integer := 63;
   constant C_M65_NO_SCRL     : integer := 64;
   constant C_M65_TAB         : integer := 65;
   constant C_M65_ALT         : integer := 66;
   constant C_M65_HELP        : integer := 67;
   constant C_M65_F9          : integer := 68;
   constant C_M65_F11         : integer := 69;
   constant C_M65_F13         : integer := 70;
   constant C_M65_ESC         : integer := 71;
   constant C_M65_CAPSLOCK    : integer := 72;
   constant C_M65_UP_CRSR     : integer := 73; -- cursor up
   constant C_M65_LEFT_CRSR   : integer := 74; -- cursor left
   constant C_M65_RESTORE     : integer := 75;
   constant C_M65_NONE        : integer := 79;

   signal   main_key_num      : integer range 0 to 79;
   signal   main_key_pressed  : std_logic;
   signal   main_key_released : std_logic;

   signal   main_uart_rx_ready : std_logic;
   signal   main_uart_rx_valid : std_logic;
   signal   main_uart_rx_data  : std_logic_vector(7 downto 0);
   signal   main_uart_tx_ready : std_logic;
   signal   main_uart_tx_valid : std_logic;
   signal   main_uart_tx_data  : std_logic_vector(7 downto 0);

   signal   main_cmd_ready : std_logic;
   signal   main_cmd_valid : std_logic;
   signal   main_cmd_data  : std_logic_vector(7 downto 0);

begin

   key_proc : process (main_clk_i)
   begin
      if rising_edge(main_clk_i) then
         main_key_pressed <= '0';

         if main_kb_key_pressed_n_i = '0' then
            if main_key_num /= main_kb_key_num_i or main_key_released = '1' then
               main_key_num      <= main_kb_key_num_i;
               main_key_pressed  <= '1';
               main_key_released <= '0';
            end if;
         end if;

         if main_kb_key_pressed_n_i = '1' then
            if main_key_num = main_kb_key_num_i then
               main_key_released <= '1';
            end if;
         end if;

         if main_rst_i = '1' then
            main_key_pressed  <= '0';
            main_key_released <= '1';
            main_key_num      <= C_M65_NONE;
         end if;
      end if;
   end process key_proc;

   uart_inst : entity work.uart
      generic map (
         G_DIVISOR => G_MAIN_CLK_HZ / G_UART_BAUDRATE
      )
      port map (
         clk_i      => main_clk_i,
         rst_i      => main_rst_i,
         uart_rx_i  => uart_rx_i,
         uart_tx_o  => uart_tx_o,
         rx_ready_i => main_uart_rx_ready,
         rx_valid_o => main_uart_rx_valid,
         rx_data_o  => main_uart_rx_data,
         tx_ready_o => main_uart_tx_ready,
         tx_valid_i => main_uart_tx_valid,
         tx_data_i  => main_uart_tx_data
      ); -- uart_inst

   main_uart_rx_ready <= main_cmd_ready;

   cmd_proc : process (main_clk_i)
   begin
      if rising_edge(main_clk_i) then
         if main_cmd_ready = '1' then
            main_cmd_valid <= '0';
         end if;

         if main_uart_rx_valid = '1' and main_uart_rx_ready = '1' then
            if main_uart_rx_data >= X"61" and main_uart_rx_data <= X"7A" then
               main_cmd_data  <= main_uart_rx_data - X"20";
               main_cmd_valid <= '1';
            else
               main_cmd_data  <= main_uart_rx_data;
               main_cmd_valid <= '1';
            end if;
         end if;

         if main_key_pressed = '1' then
            main_cmd_valid <= '1';

            case main_key_num is

               when C_M65_A =>
                  main_cmd_data <= X"41";

               when C_M65_B =>
                  main_cmd_data <= X"42";

               when C_M65_C =>
                  main_cmd_data <= X"43";

               when C_M65_D =>
                  main_cmd_data <= X"44";

               when C_M65_E =>
                  main_cmd_data <= X"45";

               when C_M65_F =>
                  main_cmd_data <= X"46";

               when C_M65_G =>
                  main_cmd_data <= X"47";

               when C_M65_H =>
                  main_cmd_data <= X"48";

               when C_M65_I =>
                  main_cmd_data <= X"49";

               when C_M65_J =>
                  main_cmd_data <= X"4A";

               when C_M65_K =>
                  main_cmd_data <= X"4B";

               when C_M65_L =>
                  main_cmd_data <= X"4C";

               when C_M65_M =>
                  main_cmd_data <= X"4D";

               when C_M65_N =>
                  main_cmd_data <= X"4E";

               when C_M65_O =>
                  main_cmd_data <= X"4F";

               when C_M65_P =>
                  main_cmd_data <= X"50";

               when C_M65_Q =>
                  main_cmd_data <= X"51";

               when C_M65_R =>
                  main_cmd_data <= X"52";

               when C_M65_S =>
                  main_cmd_data <= X"53";

               when C_M65_T =>
                  main_cmd_data <= X"54";

               when C_M65_U =>
                  main_cmd_data <= X"55";

               when C_M65_V =>
                  main_cmd_data <= X"56";

               when C_M65_W =>
                  main_cmd_data <= X"57";

               when C_M65_X =>
                  main_cmd_data <= X"58";

               when C_M65_Y =>
                  main_cmd_data <= X"59";

               when C_M65_Z =>
                  main_cmd_data <= X"5A";

               when others =>
                  main_cmd_valid <= '0';

            end case;

         end if;
      end if;
   end process cmd_proc;


   controller_inst : entity work.controller
      generic map (
         G_CELL_BITS => G_CELL_BITS,
         G_ROWS      => G_ROWS,
         G_COLS      => G_COLS
      )
      port map (
         clk_i                => main_clk_i,
         rst_i                => main_rst_i,
         cmd_valid_i          => main_cmd_valid,
         cmd_ready_o          => main_cmd_ready,
         cmd_data_i           => main_cmd_data,
         uart_tx_valid_o      => main_uart_tx_valid,
         uart_tx_ready_i      => main_uart_tx_ready,
         uart_tx_data_o       => main_uart_tx_data,
         init_density_i       => main_init_density_i,
         generational_speed_i => main_generational_speed_i,
         ready_i              => main_life_ready_i,
         step_o               => main_life_step_o,
         count_o              => main_life_gens_o,
         board_busy_o         => main_board_busy_o,
         board_addr_o         => main_board_addr_o,
         board_rd_data_i      => main_board_rd_data_i,
         board_wr_data_o      => main_board_wr_data_o,
         board_wr_en_o        => main_board_wr_en_o
      ); -- controller_inst

end architecture synthesis;

