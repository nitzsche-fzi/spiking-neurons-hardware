library ieee;
use ieee.std_logic_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

entity izhikevich is
    generic (INT_BW: integer := 7;
             FRAC_BW: integer := 15;
             A: real := 0.02;
             B: real := 0.2;
             C: real := -65.0;
             D: real := 8.0;
             THRESHOLD: real := 30.0);
    port(
         clk: in std_logic;
         in_current: in sfixed(INT_BW downto -FRAC_BW);
         out_potential: out sfixed(INT_BW downto -FRAC_BW)     
    );
       
   constant I_0: real := 140.0;
end izhikevich;

architecture standard_izhikevich of izhikevich is
   subtype fxp is sfixed(INT_BW downto -FRAC_BW);
   constant A_1_MINUS : real := 1.0 - A;
   constant AB : real := A * B;
begin
main : process(clk)
    variable v: fxp := to_sfixed(C, fxp'high, fxp'low); -- -100 << v <= 30
    variable v_tmp: fxp := v;
    variable v_sq : sfixed (sfixed_high(v'high, v'low, '*', 4, fxp'low) downto fxp'low);
    variable u: fxp := to_sfixed(C * B, fxp'high, fxp'low);
 begin
     if rising_edge(clk) then 
         v_tmp := v;  
         v_sq := resize(v * (resize(resize(v * 0.04, 3, fxp'low) + 6.0, 4, fxp'low)), v_sq);
         v := resize(resize(resize(v_sq - u, v_sq) + in_current, v_sq) + I_0, v, overflow_style => fixed_saturate);
         u := resize(resize(A_1_MINUS * u, u) + resize(v_tmp * AB, v_tmp), u);
         
         if v >= THRESHOLD then
            v := to_sfixed(C, v);
            u := resize(u + D, u);
         end if;
         
         out_potential <= v;    
     end if;  
  end process;  
end standard_izhikevich;

architecture simplified_izhikevich of izhikevich is
constant H: real := 0.78125; -- delta_t

constant I_H : real := I_0 * H;
constant A_H : real := A * H;
constant B_H : real := B * H;
constant D_H : real := D * H;
constant A_H_1_MINUS : real := 1.0 - A_H;
constant AB_H : real := A_H * B_H;

subtype fxp is sfixed(INT_BW downto -FRAC_BW);
begin
main : process(clk)
    variable v: fxp := to_sfixed(C, fxp'high, fxp'low);
    variable v_tmp: fxp;
    variable v_sq: sfixed(sfixed_high(v, '*', v) - 5 downto fxp'low);
    variable u: fxp := to_sfixed(C * B_H, fxp'high, fxp'low);
 begin
     if rising_edge(clk) then 
         v_tmp := v;  
         
         v_sq := resize(((resize(v sra 5, fxp'high-5, fxp'low) + 4.90625) * v), v_sq);      
         v := resize(resize(resize(v_sq - u, v_sq) + in_current, v_sq) + I_h, v, overflow_style => fixed_saturate);
         u := resize(resize(A_H_1_MINUS * u, u) + resize(v_tmp * AB_H, v_tmp), u);
         
         if v >= THRESHOLD then
            v := to_sfixed(C, v);
            u := resize(u + D_H, u);
         end if;
         
         out_potential <= v;    
     end if;  
  end process;  
end simplified_izhikevich;

configuration cfg_standard_izhikevich of
   izhikevich is
for standard_izhikevich
end for;
end configuration cfg_standard_izhikevich;

configuration cfg_simplified_izhikevich of
   izhikevich is
for simplified_izhikevich
end for;
end configuration cfg_simplified_izhikevich;