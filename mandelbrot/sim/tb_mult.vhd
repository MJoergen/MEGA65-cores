library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

library unisim;
   use unisim.vcomponents.all;

library unimacro;
   use unimacro.vcomponents.all;

entity tb_mult is
end entity tb_mult;

architecture sim of tb_mult is

   signal clk : std_logic := '1';
   signal rst : std_logic := '1';

   signal a_s : std_logic_vector(17 downto 0);
   signal b_s : std_logic_vector(17 downto 0);
   signal p_s : std_logic_vector(35 downto 0);

begin

   clk <= not clk after 5 ns; -- 100 MHz
   rst <= '1', '0' after 100 ns;

   test_proc : process
   begin
      wait until rst = '0';
      wait until clk = '1';
      a_s <= "11" & X"FFFF";  -- -0.000015
      b_s <= "11" & X"FFFF";  -- -0.000015
      wait until clk = '1';
      a_s <= "11" & X"FFFF";  -- -0.000015
      b_s <= "00" & X"0001";  --  0.000015
      wait until clk = '1';
      a_s <= "00" & X"0001";  --  0.000015
      b_s <= "00" & X"0001";  --  0.000015
      wait until clk = '1';
      a_s <= "01" & X"FFFF";  --  1.999985
      b_s <= "01" & X"FFFF";  --  1.999985
      wait until clk = '1';
      a_s <= "11" & X"FFFF";  -- -0.000015
      b_s <= "01" & X"FFFF";  --  1.999985
      wait until clk = '1';

      wait until clk = '1';
      wait until clk = '1';
   end process test_proc;


   mult_inst : component mult_macro
      generic map (
         DEVICE  => "7SERIES",
         LATENCY => 1,
         WIDTH_A => 18,
         WIDTH_B => 18
      )
      port map (
         clk => clk,
         rst => rst,
         ce  => '1',
         p   => p_s, -- Output
         a   => a_s, -- Input
         b   => b_s  -- Input
      ); -- mult_inst

end architecture sim;

