library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity testbench is
  generic (
    INT_BW : integer := 13;
    FRAC_BW : integer := 15;
    DIR_NAME : string := "";
    FILE_NAME : string := "output.csv";
    I : real := 1.0
  );
end testbench;

architecture beh_tb of testbench is    
  subtype fxp is sfixed(INT_BW downto -FRAC_BW);

  signal clk   : std_logic := '0';
  signal in_current : fxp;
  signal out_potential: fxp;
  signal end_of_test: boolean := false;

begin
  clk <= not clk after 10ns;  
  end_of_test <= true after 32us;
  in_current <= to_sfixed(I, in_current);    

  io: entity work.logger
  generic map(
    OUTPUT_PATH => DIR_NAME & "/def_" & FILE_NAME
  )
  port map (
    clk => clk,
    end_of_test => end_of_test,
    x => to_real(in_current),
    y => to_real(out_potential)
  );

  uut: entity work.hodgkin_huxley
  generic map(
    FRAC_BW => FRAC_BW,
    INT_BW => INT_BW
  )
  port map (
    clk       => clk,
    in_current => in_current,
    out_potential => out_potential
  );
end beh_tb;
