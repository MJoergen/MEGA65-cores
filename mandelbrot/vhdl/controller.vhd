library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std_unsigned.all;

entity controller is
   port (
      main_clk_i              : in    std_logic;
      main_rst_i              : in    std_logic;
      main_kb_key_pressed_n_i : in    std_logic;             -- low active: debounced feedback: is kb_key_num_i pressed right now?
      main_kb_key_num_i       : in    integer range 0 to 79; -- cycles through all MEGA65 keys
      main_start_o            : out   std_logic;
      main_done_i             : in    std_logic;
      main_startx_o           : out   std_logic_vector(17 downto 0);
      main_starty_o           : out   std_logic_vector(17 downto 0);
      main_stepx_o            : out   std_logic_vector(17 downto 0);
      main_stepy_o            : out   std_logic_vector(17 downto 0)
   );
end entity controller;

architecture synthesis of controller is

   -- MEGA65 key codes that kb_key_num_i is using while
   -- kb_key_pressed_n_i is signalling (low active) which key is pressed
   constant C_M65_INS_DEL     : integer             := 0;
   constant C_M65_RETURN      : integer             := 1;
   constant C_M65_HORZ_CRSR   : integer             := 2;  -- means cursor right in C64 terminology
   constant C_M65_F7          : integer             := 3;
   constant C_M65_F1          : integer             := 4;
   constant C_M65_F3          : integer             := 5;
   constant C_M65_F5          : integer             := 6;
   constant C_M65_VERT_CRSR   : integer             := 7;  -- means cursor down in C64 terminology
   constant C_M65_3           : integer             := 8;
   constant C_M65_W           : integer             := 9;
   constant C_M65_A           : integer             := 10;
   constant C_M65_4           : integer             := 11;
   constant C_M65_Z           : integer             := 12;
   constant C_M65_S           : integer             := 13;
   constant C_M65_E           : integer             := 14;
   constant C_M65_LEFT_SHIFT  : integer             := 15;
   constant C_M65_5           : integer             := 16;
   constant C_M65_R           : integer             := 17;
   constant C_M65_D           : integer             := 18;
   constant C_M65_6           : integer             := 19;
   constant C_M65_C           : integer             := 20;
   constant C_M65_F           : integer             := 21;
   constant C_M65_T           : integer             := 22;
   constant C_M65_X           : integer             := 23;
   constant C_M65_7           : integer             := 24;
   constant C_M65_Y           : integer             := 25;
   constant C_M65_G           : integer             := 26;
   constant C_M65_8           : integer             := 27;
   constant C_M65_B           : integer             := 28;
   constant C_M65_H           : integer             := 29;
   constant C_M65_U           : integer             := 30;
   constant C_M65_V           : integer             := 31;
   constant C_M65_9           : integer             := 32;
   constant C_M65_I           : integer             := 33;
   constant C_M65_J           : integer             := 34;
   constant C_M65_0           : integer             := 35;
   constant C_M65_M           : integer             := 36;
   constant C_M65_K           : integer             := 37;
   constant C_M65_O           : integer             := 38;
   constant C_M65_N           : integer             := 39;
   constant C_M65_PLUS        : integer             := 40;
   constant C_M65_P           : integer             := 41;
   constant C_M65_L           : integer             := 42;
   constant C_M65_MINUS       : integer             := 43;
   constant C_M65_DOT         : integer             := 44;
   constant C_M65_COLON       : integer             := 45;
   constant C_M65_AT          : integer             := 46;
   constant C_M65_COMMA       : integer             := 47;
   constant C_M65_GBP         : integer             := 48;
   constant C_M65_ASTERISK    : integer             := 49;
   constant C_M65_SEMICOLON   : integer             := 50;
   constant C_M65_CLR_HOME    : integer             := 51;
   constant C_M65_RIGHT_SHIFT : integer             := 52;
   constant C_M65_EQUAL       : integer             := 53;
   constant C_M65_ARROW_UP    : integer             := 54; -- symbol, not cursor
   constant C_M65_SLASH       : integer             := 55;
   constant C_M65_1           : integer             := 56;
   constant C_M65_ARROW_LEFT  : integer             := 57; -- symbol, not cursor
   constant C_M65_CTRL        : integer             := 58;
   constant C_M65_2           : integer             := 59;
   constant C_M65_SPACE       : integer             := 60;
   constant C_M65_MEGA        : integer             := 61;
   constant C_M65_Q           : integer             := 62;
   constant C_M65_RUN_STOP    : integer             := 63;
   constant C_M65_NO_SCRL     : integer             := 64;
   constant C_M65_TAB         : integer             := 65;
   constant C_M65_ALT         : integer             := 66;
   constant C_M65_HELP        : integer             := 67;
   constant C_M65_F9          : integer             := 68;
   constant C_M65_F11         : integer             := 69;
   constant C_M65_F13         : integer             := 70;
   constant C_M65_ESC         : integer             := 71;
   constant C_M65_CAPSLOCK    : integer             := 72;
   constant C_M65_UP_CRSR     : integer             := 73; -- cursor up
   constant C_M65_LEFT_CRSR   : integer             := 74; -- cursor left
   constant C_M65_RESTORE     : integer             := 75;
   constant C_M65_NONE        : integer             := 79;

   constant C_MAX_COUNT     : integer               := 511;
   constant C_NUM_ROWS      : integer               := 480;
   constant C_NUM_COLS      : integer               := 640;
   constant C_NUM_ITERATORS : integer               := 240;

   constant C_START_X : real                        := -1.6667;
   constant C_START_Y : real                        := -1.0000;
   constant C_SIZE_X  : real                        := 2.6667;
   constant C_SIZE_Y  : real                        := 2.0000;

   signal   main_active     : std_logic;
   signal   main_kb_key_num : integer range 0 to 79 := C_M65_NONE;

   -- 23 bits = 8 million cycles @ 150 MHz = 18 times pr second.
   signal   main_upd_cnt : std_logic_vector(21 downto 0);
   signal   main_upd     : std_logic;

begin

   active_proc : process (main_clk_i)
   begin
      if rising_edge(main_clk_i) then
         main_start_o <= '0';

         if main_active = '0' then
            main_active  <= '1';
            main_start_o <= '1';
         end if;

         if main_done_i = '1' then
            main_active <= '0';
         end if;

         if main_rst_i = '1' then
            main_active <= '0';
         end if;
      end if;
   end process active_proc;


   main_upd_proc : process (main_clk_i)
   begin
      if rising_edge(main_clk_i) then
         main_upd_cnt <= main_upd_cnt + 1;

         main_upd     <= '0';
         if main_upd_cnt = 0 then
            main_upd <= '1';
         end if;
      end if;
   end process main_upd_proc;


   xy_proc : process (main_clk_i)
   begin
      if rising_edge(main_clk_i) then
         if main_upd = '1' then

            case main_kb_key_num is

               when C_M65_MINUS =>
                  -- Zoom out
                  main_stepx_o <= main_stepx_o + main_stepx_o(17 downto 9) + 1;
                  main_stepy_o <= main_stepy_o + main_stepy_o(17 downto 9) + 1;

               when C_M65_PLUS =>
                  -- Zoom in
                  main_stepx_o <= main_stepx_o - main_stepx_o(17 downto 9) - 1;
                  main_stepy_o <= main_stepy_o - main_stepy_o(17 downto 9) - 1;

               when C_M65_LEFT_CRSR =>
                  -- Pan left
                  main_startx_o <= main_startx_o - main_stepx_o;

               when C_M65_HORZ_CRSR =>
                  -- Pan right
                  main_startx_o <= main_startx_o + main_stepx_o;

               when C_M65_UP_CRSR =>
                  -- Pan up
                  main_starty_o <= main_starty_o - main_stepy_o;

               when C_M65_VERT_CRSR =>
                  -- Pan down
                  main_starty_o <= main_starty_o + main_stepy_o;

               when others =>
                  null;

            end case;

            main_kb_key_num <= C_M65_NONE;
         end if;

         if main_kb_key_pressed_n_i = '0' then
            main_kb_key_num <= main_kb_key_num_i;
         end if;

         if main_rst_i = '1' then
            main_startx_o <= to_std_logic_vector(integer((C_START_X + 4.0) * real(2 ** 16)), 18);
            main_starty_o <= to_std_logic_vector(integer((C_START_Y + 4.0) * real(2 ** 16)), 18);
            main_stepx_o  <= to_std_logic_vector(integer(C_SIZE_X * real(2 ** 16)) / C_NUM_COLS, 18);
            main_stepy_o  <= to_std_logic_vector(integer(C_SIZE_Y * real(2 ** 16)) / C_NUM_ROWS, 18);
         end if;
      end if;
   end process xy_proc;

end architecture synthesis;

