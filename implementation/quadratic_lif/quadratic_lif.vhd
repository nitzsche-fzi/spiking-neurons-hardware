library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity QuadraticLIF is
    generic (FRAC_BW : integer := 15;
         THRESHOLD : real := 10.0;
         THETA : real := 1.75;
         LOG_TAU : integer := 2
    );

    port (clk: in std_logic;
      in_current: in sfixed(4 downto -FRAC_BW);
      out_potential: out sfixed(4 downto -FRAC_BW));
end QuadraticLIF;

architecture beh of QuadraticLIF is
    subtype fxp is sfixed(4 downto -FRAC_BW);
begin

main : process(clk)
    variable v: fxp := to_sfixed(0.0, fxp'high, fxp'low);
    variable v_sq: sfixed(sfixed_high(v, '*', v) downto fxp'low);
        
    begin
     if rising_edge(clk) then 
        v_sq := resize(resize(v - THETA, v) * v, v_sq);
        v := resize(v + ((v_sq + in_current) sra LOG_TAU), v, fixed_saturate);
        
        if v >= THRESHOLD then
            v := to_sfixed(0.0, v);
        end if;
        
        out_potential <= v;
     end if;  
  end process;  

end beh;
