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

library std;
   use std.textio.all;

entity uart_dumper is
   port (
      clk_i      : in    std_logic;
      rst_i      : in    std_logic;
      rx_ready_i : in    std_logic;
      rx_valid_i : in    std_logic;
      rx_data_i  : in    std_logic_vector(7 downto 0)
   );
end entity uart_dumper;

architecture simulation of uart_dumper is

begin

   uart_rx_proc : process (clk_i)
      variable l : line;
   begin
      if rising_edge(clk_i) then
         if rx_valid_i = '1' and rx_ready_i = '1' then
            if rx_data_i = X"0D" then
               null;
            elsif rx_data_i = X"0A" then
               writeline(output, l);
            else
               write(l, character'val(to_integer(rx_data_i)));
            end if;
         end if;
      end if;
   end process uart_rx_proc;

end architecture simulation;

