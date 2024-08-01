library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity board_mem is
   generic (
      G_COLS : integer;
      G_ROWS : integer
   );
   port (
      a_clk_i   : in    std_logic;
      a_rst_i   : in    std_logic;
      a_ready_o : out   std_logic;
      a_valid_i : in    std_logic;
      a_board_i : in    std_logic_vector(G_COLS * G_ROWS - 1 downto 0);
      a_addr_i  : in    std_logic_vector(19 downto 0);
      a_data_o  : out   std_logic;
      b_clk_i   : in    std_logic;
      b_addr_i  : in    std_logic_vector(19 downto 0);
      b_data_o  : out   std_logic
   );
end entity board_mem;

architecture synthesis of board_mem is

   signal a_addr : std_logic_vector(19 downto 0);
   signal a_data : std_logic_vector(0 downto 0);
   signal a_wren : std_logic;

   type   state_type is (IDLE_ST, BUSY_ST);
   signal state : state_type := IDLE_ST;

begin

   a_ready_o <= '1' when state = IDLE_ST else
                '0';

   fsm_proc : process (a_clk_i)
   begin
      if rising_edge(a_clk_i) then
         a_wren <= '0';

         case state is

            when IDLE_ST =>
               a_addr <= a_addr_i;
               if a_valid_i = '1' and a_ready_o = '1' then
                  a_addr <= (others => '0');
                  state  <= BUSY_ST;
               end if;

            when BUSY_ST =>
               a_data <= "" & a_board_i(to_integer(a_addr));
               a_wren <= '1';
               a_addr <= a_addr + 1;
               if a_addr = G_COLS * G_ROWS - 1 then
                  state <= IDLE_ST;
               end if;

         end case;

         if a_rst_i = '1' then
            state <= IDLE_ST;
         end if;
      end if;
   end process fsm_proc;

   tdp_ram : entity work.tdp_ram
      generic map (
         ADDR_WIDTH => 20,
         DATA_WIDTH => 1
      )
      port map (
         clock_a   => a_clk_i,
         clen_a    => '1',
         address_a => a_addr,
         data_a    => a_data,
         wren_a    => a_wren,
         q_a(0)    => a_data_o,

         clock_b   => b_clk_i,
         clen_b    => '1',
         address_b => b_addr_i,
         data_b    => "0",
         wren_b    => '0',
         q_b(0)    => b_data_o
      ); -- tdp_ram

end architecture synthesis;

