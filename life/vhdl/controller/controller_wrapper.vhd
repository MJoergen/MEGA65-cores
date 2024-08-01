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
      G_ROWS          : integer;
      G_COLS          : integer
   );
   port (
      main_clk_i              : in    std_logic;
      main_rst_i              : in    std_logic;
      main_kb_key_num_i       : in    integer range 0 to 79;
      main_kb_key_pressed_n_i : in    std_logic;
      uart_tx_o               : out   std_logic;
      uart_rx_i               : in    std_logic;
      main_life_board_addr_o  : out   std_logic_vector(19 downto 0);
      main_life_board_data_i  : in    std_logic;
      main_life_step_o        : out   std_logic;
      main_life_wr_index_o    : out   integer range G_ROWS * G_COLS - 1 downto 0;
      main_life_wr_value_o    : out   std_logic;
      main_life_wr_en_o       : out   std_logic;
      main_life_init_done_o   : out   std_logic;
      main_life_count_o       : out   std_logic_vector(15 downto 0)
   );
end entity controller_wrapper;

architecture synthesis of controller_wrapper is

   signal main_uart_rx_ready : std_logic;
   signal main_uart_rx_valid : std_logic;
   signal main_uart_rx_data  : std_logic_vector(7 downto 0);
   signal main_uart_tx_ready : std_logic;
   signal main_uart_tx_valid : std_logic;
   signal main_uart_tx_data  : std_logic_vector(7 downto 0);

begin

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

   controller_inst : entity work.controller
      generic map (
         G_ROWS => G_ROWS,
         G_COLS => G_COLS
      )
      port map (
         clk_i                   => main_clk_i,
         rst_i                   => main_rst_i,
         main_kb_key_num_i       => main_kb_key_num_i,
         main_kb_key_pressed_n_i => main_kb_key_pressed_n_i,
         uart_rx_valid_i         => main_uart_rx_valid,
         uart_rx_ready_o         => main_uart_rx_ready,
         uart_rx_data_i          => main_uart_rx_data,
         uart_tx_valid_o         => main_uart_tx_valid,
         uart_tx_ready_i         => main_uart_tx_ready,
         uart_tx_data_o          => main_uart_tx_data,
         board_addr_o            => main_life_board_addr_o,
         board_data_i            => main_life_board_data_i,
         step_o                  => main_life_step_o,
         wr_index_o              => main_life_wr_index_o,
         wr_value_o              => main_life_wr_value_o,
         wr_en_o                 => main_life_wr_en_o,
         init_done_o             => main_life_init_done_o
      ); -- controller_inst

   main_life_count_proc : process (main_clk_i)
   begin
      if rising_edge(main_clk_i) then
         if main_life_step_o then
            main_life_count_o <= main_life_count_o + 1;
         end if;
         if main_rst_i then
            main_life_count_o <= (others => '0');
         end if;
      end if;
   end process main_life_count_proc;

end architecture synthesis;

