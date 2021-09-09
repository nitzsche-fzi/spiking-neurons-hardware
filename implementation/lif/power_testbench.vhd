library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity testbench is
  generic (
    DATA_WIDTH : integer := 16
  );
end testbench;

architecture PostSynthesis of testbench is
  signal clk   : std_logic := '0';

  signal in_current : std_logic_vector(DATA_WIDTH downto 0);
  signal out_potential: std_logic_vector(DATA_WIDTH-1 downto 0);

  signal I : real := 1.0;
  
begin
  clk <= not clk after 5ns;
  in_current <= to_slv(to_ufixed(I, 0, -DATA_WIDTH));  

  uut: entity work.liaf
    port map (
      clk => clk,
      in_current => in_current,
      out_potential => out_potential
    );

  random: entity work.rng
    generic map (
      MIN => 1.0,
      MAX => 1.5
    )

    port map (
      clk => clk,
      random_number => I
  );
end PostSynthesis;
