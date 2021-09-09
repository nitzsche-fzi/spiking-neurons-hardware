library ieee;
use ieee.std_logic_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

use work.pwr_pkg.all;

entity ExpLIF is
    generic (FRAC_BW : integer := 15;
         THRESHOLD : real := 10.0;
         THETA : real := 1.75;
         LOG_TAU : integer := 2;
         CORDIC : boolean := true;
         POWER2_BASE : boolean := false
    );

    port (clk: in std_logic;
      in_current: in sfixed(4 downto -FRAC_BW);
      out_potential: out sfixed(4 downto -FRAC_BW));
end ExpLIF;

architecture beh of ExpLIF is
    subtype fxp is sfixed(4 downto -FRAC_BW);
begin

main : process(clk)
    variable v: fxp := to_sfixed(0.0, fxp'high, fxp'low);
    variable tmp: fxp; 
    variable exp_tmp: sfixed(exp_high((THRESHOLD - THETA), POWER2_BASE) downto -FRAC_BW);
        
    begin
     if rising_edge(clk) then 
        tmp := resize(v - THETA, tmp);

        if not CORDIC then
            exp_tmp := exp(tmp, exp_tmp'high, base_two => POWER2_BASE, log2_e => LOG2_E_FAST);
        else
            exp_tmp := exp_cordic(tmp, exp_tmp'high);
        end if;
             
        v := resize(v + ((resize(resize(exp_tmp - v, exp_tmp) + in_current, exp_tmp)) sra LOG_TAU), v, fixed_saturate);
        
        if v >= THRESHOLD then
            v := to_sfixed(0.0, v);
        end if;
        
        out_potential <= v;
     end if;  
  end process;  

end beh;
