library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity testbench is
  generic (
    DW : integer := 16;
    LOG_TAU : integer := 4;
    DIR_NAME : string := "";
    FILE_NAME : string := "output.csv";
    I : real := 1.0
  );
end testbench;

architecture Behavioral of testbench is
  signal clk   : std_logic := '0';

  signal in_current : unsigned(DW downto 0);
  signal out_potential: unsigned(DW-1 downto 0);
  signal end_of_test: boolean := false;

  signal r: ufixed(-1 downto -DW);
  signal old_r : ufixed(-1 downto -DW);
  
begin
  clk <= not clk after 10ns; 
  in_current <= unsigned(to_slv(to_ufixed(I, 0, -DW)));  
  end_of_test <= true after 2us;
  r <= to_ufixed(std_logic_vector(out_potential), r);
  old_r <= r;
  io: entity work.logger
  generic map(OUTPUT_PATH => DIR_NAME & "/" & FILE_NAME)
  port map (
    clk => clk,
    end_of_test => end_of_test,
    x => I,
    y => to_real(old_r)
  );

  uut: entity work.liaf
    generic map(
      DATA_WIDTH => DW,
      LOG_TAU => LOG_TAU
    )
    port map (
      clk => clk,
      in_current => in_current,
      out_potential => out_potential
    );
end Behavioral;
