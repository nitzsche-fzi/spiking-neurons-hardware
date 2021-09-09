library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity liaf is
    generic (DATA_WIDTH: integer := 16;
             C: integer := 17;
             RC: integer := 20;
             LOG_TAU : integer := 4);
    port(
         clk: in std_logic;
         in_current: in unsigned(DATA_WIDTH downto 0);
         out_potential: out unsigned(DATA_WIDTH - 1 downto 0)
    );    
end liaf;

architecture liaf_beh_simple of liaf is 
begin
    main : process(clk)
    variable v: unsigned(DATA_WIDTH downto 0) := to_unsigned(0, DATA_WIDTH + 1); -- DATA_WIDTH integer with overflow flag

 begin
     if rising_edge(clk) then       
         v := v(DATA_WIDTH - 1 downto 0) + shift_right(in_current - v(DATA_WIDTH - 1 downto 0), LOG_TAU);

         if (v(DATA_WIDTH) = '1') then
            v := to_unsigned(0, DATA_WIDTH + 1);
         end if;
         
         out_potential <= v(DATA_WIDTH - 1 downto 0);
     end if;  
  end process;
 
end liaf_beh_simple;
