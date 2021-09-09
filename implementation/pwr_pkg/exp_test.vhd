library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

use work.pwr_pkg.all;

entity exp_test is
   generic(
      INT_IN:  integer := 5;
      INT_OUT: integer := 15;
      FRAC_BW: integer := 22
   );
   port(
      clk: in std_logic;
      x: in sfixed(INT_IN downto -FRAC_BW);
      y: out sfixed(INT_OUT downto -FRAC_BW)
   );
end exp_test;

architecture cordic_based of exp_test is   
begin
   main : process(clk)  
   begin
      if rising_edge(clk) then         
         y <= exp_cordic(x, INT_OUT);
      end if;  
   end process;  
end cordic_based;

architecture power2_based of exp_test is      
begin
   main : process(clk)  
   begin   
      if rising_edge(clk) then 
         y <= exp(x, INT_OUT);      
      end if;  
   end process;  
end power2_based;

architecture power2 of exp_test is      
begin
   main : process(clk)  
   begin   
      if rising_edge(clk) then 
         y <= exp(x, INT_OUT, base_two => true);      
      end if;  
   end process;  
end power2;

architecture power2_based_opt of exp_test is      
begin
   main : process(clk)  
   begin   
      if rising_edge(clk) then 
         y <= exp(x, INT_OUT, log2_e => LOG2_E_FAST);      
      end if;  
   end process;  
end power2_based_opt;

configuration cfg_cordic of
exp_test is
for cordic_based
end for;
end configuration cfg_cordic;

configuration cfg_pwr2_based of
   exp_test is
for power2_based
end for;
end configuration cfg_pwr2_based;

configuration cfg_pwr2_based_opt of
   exp_test is
for power2_based_opt
end for;
end configuration cfg_pwr2_based_opt;

configuration cfg_pwr2 of
   exp_test is
for power2
end for;
end configuration cfg_pwr2;
