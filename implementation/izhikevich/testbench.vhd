library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity testbench is
  generic (
    INT_BW : integer := 7;
    FRAC_BW : integer := 15;
    DIR_NAME : string := "";
    FILE_NAME : string := "output.csv";
    STANDARD : boolean := true;
    I: real := 5.0
  );
end testbench;

architecture beh_tb of testbench is
  subtype fxp is sfixed(INT_BW downto -FRAC_BW);

  signal clk   : std_logic := '0';
  signal in_current : fxp;
  signal out_standard: fxp;
  signal out_simplified: fxp;
  signal end_of_test: boolean := false;

begin
  clk <= not clk after 10ns;   
  end_of_test <= true after 2us;

  s1: if STANDARD generate    
    in_current <= to_sfixed(I, in_current); 

    io_standard: entity work.logger
    generic map(
      OUTPUT_PATH => DIR_NAME & "/standard_" & FILE_NAME
    )
    port map (
      clk => clk,
      end_of_test => end_of_test,
      x => to_real(in_current),
      y => to_real(out_standard)
    );
    
    default: entity work.izhikevich (standard_izhikevich)
    generic map(
      FRAC_BW => FRAC_BW,
      INT_BW => INT_BW
    )
    port map (
    clk       => clk,
    in_current => in_current,
    out_potential => out_standard
    );
  end generate s1;

  s2: if not STANDARD generate  
    in_current <= to_sfixed(I * 0.78125, in_current);

    io_simple: entity work.logger
    generic map(
      OUTPUT_PATH => DIR_NAME & "/opt_" & FILE_NAME
    )
    port map (
      clk => clk,
      end_of_test => end_of_test,
      x => I,
      y => to_real(out_simplified)
    );

    simple: entity work.izhikevich (simplified_izhikevich)
    generic map(
      FRAC_BW => FRAC_BW,
      INT_BW => INT_BW
    )
    port map (
    clk       => clk,
    in_current => in_current,
    out_potential => out_simplified
    );
  end generate s2;
end beh_tb;
