library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fixed_pkg.all;

package pwr_pkg is
    constant LOG2_E_PRECISE : real := 1.44269504089;
    constant LOG2_E_FAST : real := 1.4375;
    function exp_high(constant max_x : real; constant base_two : boolean := false; constant log2_e : real := LOG2_E_PRECISE) return integer;
    function exp(x: sfixed; constant out_high: integer; constant base_two : boolean := false; constant log2_e : real := LOG2_E_PRECISE) return sfixed;
    function exp_cordic(x: sfixed; constant out_high: integer) return sfixed;
    function sinh(x: sfixed; constant out_high_exp: integer) return sfixed;
    function cosh(x: sfixed; constant out_high_exp: integer) return sfixed;
    function tanh(x: sfixed; constant out_high_exp: integer) return sfixed;
end pwr_pkg;

package body pwr_pkg is
    function exp_high(constant max_x: real; constant base_two: boolean := false; constant log2_e : real := LOG2_E_PRECISE) return integer is
        constant ret : integer := integer(log2_e * max_x) + 1;
        constant ret2 : integer := integer(max_x) + 1;
    begin
        if base_two then
            return ret2;
        else
            return ret;        
        end if;
    end;

    function exp(x: sfixed; constant out_high: integer; constant base_two : boolean := false; constant log2_e : real := LOG2_E_PRECISE) return sfixed is    
        subtype fxp is sfixed(x'high downto x'low);
        subtype int_part is signed(x'high+1 downto 0);
    
        variable tmp : sfixed(x'high+1 downto x'low);
        variable n: int_part;
        variable f: fxp;
        variable raw : std_logic_vector(fxp'high-fxp'low+1 downto 0);
        variable frac: std_logic_vector(-(fxp'low+1) downto 0);
        variable res: sfixed(out_high downto fxp'low);
    begin
        if base_two then
            tmp := resize(x, tmp);  
        else
            tmp := resize(x * log2_e, tmp);   
        end if;
        raw := to_slv(tmp);
        n := signed(raw(raw'high downto -fxp'low));
        frac := raw(frac'high downto 0);

        res := resize(to_sfixed("01" & frac, 1, fxp'low), out_high, fxp'low);

        return res sll to_integer(n);
    end;

    function exp_cordic(x: sfixed; constant out_high: integer) return sfixed is 
        subtype fxp is sfixed(out_high downto x'low);
        subtype int_part is signed(x'high downto 0); 

        type t_array_lut is array (-1 downto -52) of real;
        type t_array_lut2 is array (-22 to 22) of fxp;
        
        constant A : t_array_lut := (1.6487212707001282,1.2840254166877414,1.1331484530668263,1.0644944589178593,1.0317434074991028,1.0157477085866857,1.007843097206448,1.0039138893383475,1.0019550335910028,1.0009770394924165,1.0004884004786945,1.0002441704297478,1.0001220777633837,1.0000610370189331,1.000030518043791,1.0000152589054785,1.000007629423635,1.0000038147045416,1.0000019073504518,1.0000009536747712,1.000000476837272,1.0000002384186075,1.0000001192092967,1.0000000596046466,1.0000000298023228,1.0000000149011612,1.0000000074505806,1.0000000037252903,1.0000000018626451,1.0000000009313226,1.0000000004656613,1.0000000002328306,1.0000000001164153,1.0000000000582077,1.0000000000291038,1.000000000014552,1.000000000007276,1.000000000003638,1.000000000001819,1.0000000000009095,1.0000000000004547,1.0000000000002274,1.0000000000001137,1.0000000000000568,1.0000000000000284,1.0000000000000142,1.000000000000007,1.0000000000000036,1.0000000000000018,1.0000000000000009,1.0000000000000004,1.0000000000000002);
        constant B : t_array_lut2 := (to_sfixed(2.7894680928689246e-10, fxp'high, fxp'low),to_sfixed(7.582560427911907e-10, fxp'high, fxp'low),to_sfixed(2.061153622438558e-09, fxp'high, fxp'low),to_sfixed(5.602796437537268e-09, fxp'high, fxp'low),to_sfixed(1.522997974471263e-08, fxp'high, fxp'low),to_sfixed(4.139937718785167e-08, fxp'high, fxp'low),to_sfixed(1.1253517471925912e-07, fxp'high, fxp'low),to_sfixed(3.059023205018258e-07, fxp'high, fxp'low),to_sfixed(8.315287191035679e-07, fxp'high, fxp'low),to_sfixed(2.2603294069810542e-06, fxp'high, fxp'low),to_sfixed(6.14421235332821e-06, fxp'high, fxp'low),to_sfixed(1.670170079024566e-05, fxp'high, fxp'low),to_sfixed(4.5399929762484854e-05, fxp'high, fxp'low),to_sfixed(0.00012340980408667956, fxp'high, fxp'low),to_sfixed(0.00033546262790251185, fxp'high, fxp'low),to_sfixed(0.0009118819655545162, fxp'high, fxp'low),to_sfixed(0.0024787521766663585, fxp'high, fxp'low),to_sfixed(0.006737946999085467, fxp'high, fxp'low),to_sfixed(0.01831563888873418, fxp'high, fxp'low),to_sfixed(0.049787068367863944, fxp'high, fxp'low),to_sfixed(0.1353352832366127, fxp'high, fxp'low),to_sfixed(0.36787944117144233, fxp'high, fxp'low),to_sfixed(1.0, fxp'high, fxp'low),to_sfixed(2.718281828459045, fxp'high, fxp'low),to_sfixed(7.38905609893065, fxp'high, fxp'low),to_sfixed(20.085536923187668, fxp'high, fxp'low),to_sfixed(54.598150033144236, fxp'high, fxp'low),to_sfixed(148.4131591025766, fxp'high, fxp'low),to_sfixed(403.4287934927351, fxp'high, fxp'low),to_sfixed(1096.6331584284585, fxp'high, fxp'low),to_sfixed(2980.9579870417283, fxp'high, fxp'low),to_sfixed(8103.083927575384, fxp'high, fxp'low),to_sfixed(22026.465794806718, fxp'high, fxp'low),to_sfixed(59874.14171519782, fxp'high, fxp'low),to_sfixed(162754.79141900392, fxp'high, fxp'low),to_sfixed(442413.3920089205, fxp'high, fxp'low),to_sfixed(1202604.2841647768, fxp'high, fxp'low),to_sfixed(3269017.3724721107, fxp'high, fxp'low),to_sfixed(8886110.520507872, fxp'high, fxp'low),to_sfixed(24154952.7535753, fxp'high, fxp'low),to_sfixed(65659969.13733051, fxp'high, fxp'low),to_sfixed(178482300.96318725, fxp'high, fxp'low),to_sfixed(485165195.4097903, fxp'high, fxp'low),to_sfixed(1318815734.4832146, fxp'high, fxp'low),to_sfixed(3584912846.131592, fxp'high, fxp'low));
        variable exp_x : fxp;
        variable n: int_part;
        variable raw : std_logic_vector(x'high-fxp'low downto 0);
        variable frac_raw: std_logic_vector(-1 downto fxp'low);
    begin 
        raw := to_slv(x);
        n := signed(raw(raw'high downto -fxp'low));
        frac_raw := raw(-(fxp'low+1) downto 0);        
 
        exp_x := B(to_integer(n));
        
        for i in -1 downto fxp'low loop
            if frac_raw(i) = '1' then
                exp_x := resize(exp_x * A(i), fxp'high, fxp'low);
            end if;
        end loop;

        return exp_x;
    end;
    
    function sinh(x: sfixed; constant out_high_exp: integer) return sfixed is  
    begin
        return scalb((exp(x, out_high_exp) - exp(resize(-x, x), out_high_exp)), -1);     
    end;
    
    function cosh(x: sfixed; constant out_high_exp: integer) return sfixed is  
    begin
        return scalb((exp(x, out_high_exp) + exp(resize(-x, x), out_high_exp)), -1);   
    end;
    
    function tanh(x: sfixed; constant out_high_exp: integer) return sfixed is 
    begin
        return resize(sinh(x, out_high_exp) / cosh(x, out_high_exp), 1, x'low);       
    end;
end pwr_pkg;