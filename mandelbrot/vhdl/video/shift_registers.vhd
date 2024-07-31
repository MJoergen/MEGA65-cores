library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

library unisim;
   use unisim.vcomponents.all;

entity shift_registers is
   generic (
      G_DATA_SIZE : natural;
      G_DEPTH     : natural
   );
   port (
      clk_i   : in    std_logic;
      clken_i : in    std_logic;
      data_i  : in    std_logic_vector(G_DATA_SIZE - 1 downto 0);
      data_o  : out   std_logic_vector(G_DATA_SIZE - 1 downto 0)
   );
end entity shift_registers;

architecture synthesis of shift_registers is

begin

   srl_gen : for i in G_DATA_SIZE - 1 downto 0 generate

      srlc32e_inst : component srlc32e
         port map (
            clk => clk_i,
            ce  => clken_i,
            q31 => open,
            a   => to_stdlogicvector(G_DEPTH, 5),
            d   => data_i(i),
            q   => data_o(i)
         ); -- srlc32e_inst

   end generate srl_gen;

end architecture synthesis;
