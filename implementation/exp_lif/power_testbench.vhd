library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity testbench is
  generic (
    INT_BW : integer := 4;
    FRAC_BW : integer := 15;
    CORDIC: boolean := false;
    POWER2_BASE : boolean := false;
    CLOCK_PERIOD : time := 5ns
  );
end testbench;

architecture PostSynthesis of testbench is
  signal clk   : std_logic := '0';

  signal in_current : std_logic_vector(INT_BW+FRAC_BW downto 0);
  signal out_potential: std_logic_vector(INT_BW+FRAC_BW downto 0);

  signal I: real := 0.75;
  
begin
  clk <= not clk after CLOCK_PERIOD;
  in_current <= to_slv(to_sfixed(I, INT_BW, -FRAC_BW));  

  uut: entity work.ExpLIF
    port map (
      clk => clk,
      in_current => in_current,
      out_potential => out_potential
    );

  random: entity work.rng
    generic map (
      MIN => 0.75,
      MAX => 1.25
    )
    port map (
      clk => clk,
      random_number => I
  );
end PostSynthesis;
