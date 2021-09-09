library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.fixed_pkg.all;

use work.pwr_pkg.all;

entity hodgkin_huxley is
generic (INT_BW : integer := 13;
         FRAC_BW : integer := 15;
         DELTA_T: real := 0.06125);
         
port (clk: in std_logic;
      in_current: in sfixed(INT_BW downto -FRAC_BW);
      out_potential: out sfixed(INT_BW downto -FRAC_BW));
end hodgkin_huxley;

architecture hh of hodgkin_huxley is
subtype fxp is sfixed(INT_BW downto -FRAC_BW);
    constant E_K: real := -77.0; 
    constant E_Na: real := 55.0;
    constant E_L: real := -65.0;
    constant g_K: real := 35.0;
    constant g_Na: real := 40.0;
    constant g_L: real := 0.3;
begin
main : process(clk)
      constant exp_max_alpha_n : integer := exp_high(10.0);
      constant exp_max_beta_n : integer := exp_high(0.0);
      constant exp_max_alpha_m : integer := exp_high(30.0/9.0);
      constant exp_max_beta_m : integer := exp_high(60.0/9.0);
      constant exp_max_alpha_h : integer := exp_high(75.0/6.0);
      constant exp_max_beta_h : integer := exp_high(60.0/9.0);

      variable v: fxp := to_sfixed(0.0, in_current);
      variable n: fxp := to_sfixed(0.0, in_current);
      variable m: fxp := to_sfixed(0.0, in_current);
      variable h: fxp := to_sfixed(0.0, in_current);

    variable alpha_n: fxp;
    variable alpha_m: fxp;
    variable alpha_h: fxp;
    variable beta_n: fxp;
    variable beta_m: fxp;
    variable beta_h: fxp;

    variable delta_v: fxp;
    variable delta_n: fxp;
    variable delta_m: fxp;
    variable delta_h: fxp;

    variable tmp: fxp;
    variable tmp2: fxp;
    
    begin
     if rising_edge(clk) then 
      tmp := resize(v - 25.0, v);
      tmp2 := resize(tmp / 9.0, v);
      alpha_n := resize(0.02 * tmp / (1.0 - resize(exp_cordic(-tmp2, exp_max_alpha_n), v)), v); 
      beta_n := resize(-0.002 * tmp / (1.0 - resize(exp_cordic(tmp2, exp_max_beta_n), v)), v); 

      tmp := resize(v + 35.0, v);
      tmp2 := resize(tmp / 9.0, v);
      alpha_m := resize(0.182 * tmp / (1.0 - resize(exp_cordic(-tmp2, exp_max_alpha_m), v)), v); 
      beta_m := resize(-0.124 * tmp / (1.0 - resize(exp_cordic(tmp2, exp_max_beta_m), v)), v); 
      
      tmp := resize(v + 90.0, v);
      alpha_h := resize(exp_cordic(-tmp/12.0, exp_max_alpha_h), v) sra 2;
      beta_h := resize(exp_cordic(((v+62.0)-(tmp sra 1))/6.0, exp_max_beta_h), v) sra 2;

      tmp := resize(n * n, v);
      tmp := resize(tmp * tmp, v);

      tmp2 := resize(m * m, v);
      tmp2 := resize(tmp2 * m, v);
      
      v := resize(((in_current - g_K * tmp * (v-E_K) - g_Na * tmp2 * h * (v-E_Na) - g_L * (v - E_L)) sra 4) + v, v);
      n := resize(((alpha_n * (1-n) - beta_n * n) sra 4) + n, v);
      m := resize(((alpha_m * (1-m) - beta_m * m) sra 4) + m, v);
      h := resize(((alpha_h * (1-h) - beta_h * h) sra 4) + h, v);

      out_potential <= v;
     end if;  
  end process; 
end hh;
