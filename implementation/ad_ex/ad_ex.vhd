library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

use work.pwr_pkg.all;

entity AdEx is
    generic (
        FRAC_BW : integer := 15;
        CORDIC : boolean := true;
        THRESHOLD : real := 10.0;
        LOG_TAU_M : integer := 2;
        LOG_TAU_W : integer := 7;
        POWER2_BASE : boolean := false;
        THETA : real := 1.75;
        B: real := 1.0
    );
    port (
        clk: in std_logic;
        in_current: in sfixed(4 downto -FRAC_BW);
        out_potential: out sfixed(4 downto -FRAC_BW)
    );
end AdEx;

architecture ad_ex_impl of AdEx is
begin
    main : process(clk)
        variable v: sfixed(4 downto -FRAC_BW) := to_sfixed(0.0, 4, -FRAC_BW);
        variable w: sfixed(4 downto -FRAC_BW) := to_sfixed(0.0, 4, -FRAC_BW);
        variable tmp: sfixed(4 downto -FRAC_BW);
        variable exp_tmp: sfixed(exp_high((THRESHOLD - THETA)) downto -FRAC_BW);       
    begin
        if rising_edge(clk) then 
            tmp := resize((v - THETA), tmp);

            if not CORDIC then
                exp_tmp := exp(tmp, exp_tmp'high, base_two => POWER2_BASE, log2_e => LOG2_E_FAST);
            else                
                exp_tmp := exp_cordic(tmp, exp_tmp'high);
            end if;
            
            tmp := v;
            
            v := resize(v + ((resize(resize(resize(exp_tmp - tmp, exp_tmp) + in_current, exp_tmp) - w, exp_tmp)) sra LOG_TAU_M), v, fixed_saturate);
            w := resize(w + (-w sra LOG_TAU_W), w);
            
            if v >= THRESHOLD then
                v := to_sfixed(0.0, v);
                w := resize(w + b, w);
            end if;
            
            out_potential <= v;
        end if;  
    end process;
end ad_ex_impl;
