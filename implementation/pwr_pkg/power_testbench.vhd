library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;
use work.pwr_pkg.all;

entity testbench is
  generic (
    FRAC_BW : integer := 15
  );
end testbench;

architecture PostSynthesis of testbench is
  constant INT_BW : integer := 5;
  
  constant MIN_MAX_X : real := 10.0;

  signal clk   : std_logic := '0';  

  signal x : sfixed(INT_BW downto -FRAC_BW);
  signal y : sfixed(exp_high(MIN_MAX_X) downto -FRAC_BW);
  signal I : real;
begin
  clk <= not clk after 5ns;

  x <= to_sfixed(I, INT_BW, -FRAC_BW);

  uut: entity work.exp_test
  port map (
    clk => clk,
    x => x,
    y => y
  ); 

  random: entity work.rng
    generic map (
      MIN => -MIN_MAX_X,
      MAX => MIN_MAX_X
    )
    port map (
      clk => clk,
      random_number => I
  );
end PostSynthesis;
