library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity testbench is
  generic (
    FRAC_BW : integer := 15;
    DIR_NAME : string := "";
    FILE_NAME : string := "output.csv";
    I : real := 1.0
  );
end testbench;

architecture beh_tb of testbench is    
  subtype fxp is sfixed(4 downto -FRAC_BW);

  signal clk   : std_logic := '0';
  signal in_current : fxp;
  signal out_cordic, out_power2: fxp;
  signal end_of_test: boolean := false;
begin
  clk <= not clk after 10ns;   
  end_of_test <= true after 2us;
  
  in_current <= to_sfixed(I, in_current);   

  io_power2: entity work.logger
  generic map(
    OUTPUT_PATH => DIR_NAME & "/power2_" & FILE_NAME
  )
  port map (
    clk => clk,
    end_of_test => end_of_test,
    x => to_real(in_current),
    y => to_real(out_power2)
  );

  io_cordic: entity work.logger
  generic map(
    OUTPUT_PATH => DIR_NAME & "/cordic_" & FILE_NAME
  )
  port map (
    clk => clk,
    end_of_test => end_of_test,
    x => to_real(in_current),
    y => to_real(out_cordic)
  );

  uut: entity work.AdEx
  generic map(
    FRAC_BW => FRAC_BW,
    CORDIC => false
  )
  port map (
    clk => clk,
    in_current => in_current,
    out_potential => out_power2
  );

  uut2: entity work.AdEx
  generic map(
    FRAC_BW => FRAC_BW
  )
  port map (
    clk => clk,
    in_current => in_current,
    out_potential => out_cordic
  );
end beh_tb;