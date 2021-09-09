library ieee;
use ieee.std_logic_1164.all;

use work.fixed_pkg.all;
use work.pwr_pkg.all;

library std;
use std.textio.all;
use std.env.all;

entity testbench is
  generic (
    FRAC_BW : integer := 15;
    DIR_NAME : string := "";
    FILE_NAME : string := "output.csv"
  );
end testbench;

architecture beh_tb of testbench is
  constant INT_BW : integer := 5;
  
  constant DELTA_X: real := 2.0**(-12);
  constant MIN_MAX_X : real := 10.0;

  signal clk   : std_logic := '0';  

  signal x : sfixed(INT_BW downto -FRAC_BW) := to_sfixed(-MIN_MAX_X, INT_BW, -FRAC_BW);
  signal y, y2, y3: sfixed(exp_high(MIN_MAX_X) downto -FRAC_BW);
  signal end_of_test: boolean := false;
  
begin
  clk <= not clk after 10ns;   
  process(clk) begin   
    if rising_edge(clk) then      
      x <= resize(x + DELTA_X, x);
      if (x > to_sfixed(MIN_MAX_X, x)) then
        end_of_test <= true;
      end if;        
    end if;    
  end process;
    
  io: entity work.logger
  generic map(
    OUTPUT_PATH => DIR_NAME & "/power2_based_" & FILE_NAME
  )
  port map (
    clk => clk,
    end_of_test => end_of_test,
    x => to_real(x),
    y => to_real(y)
  );    

  io_opt: entity work.logger
  generic map(
    OUTPUT_PATH => DIR_NAME & "/power2_based_opt_" & FILE_NAME
  )
  port map (
    clk => clk,
    end_of_test => end_of_test,
    x => to_real(x),
    y => to_real(y3)
  );   

  io_cordic: entity work.logger
  generic map(
    OUTPUT_PATH => DIR_NAME & "/cordic_" & FILE_NAME
  )
  port map (
    clk => clk,
    end_of_test => end_of_test,
    x => to_real(x),
    y => to_real(y2)
  );  
  
  uut: entity work.exp_test (power2_based)
  generic map(
    FRAC_BW => FRAC_BW,
    INT_IN => INT_BW,
    INT_OUT => y'high
  )
  port map (
    clk => clk,
    x => x,
    y => y
  );    
  
  uut_cordic: entity work.exp_test (cordic_based)
  generic map(
    FRAC_BW => FRAC_BW,
    INT_IN => INT_BW,
    INT_OUT => y2'high
  )
  port map (
    clk => clk,
    x => x,
    y => y2
  );  

  uut_opt: entity work.exp_test (power2_based_opt)
  generic map(
    FRAC_BW => FRAC_BW,
    INT_IN => INT_BW,
    INT_OUT => y'high
  )
  port map (
    clk => clk,
    x => x,
    y => y3
  ); 
end beh_tb;
