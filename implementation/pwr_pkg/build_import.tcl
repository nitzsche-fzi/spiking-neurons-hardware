read_vhdl ../../utils/fixed_pkg_2008.vhd
read_vhdl ../pwr.vhd
exec xvhdl ../pwr.vhd
exec xvhdl ../exp_test.vhd
read_vhdl ../exp_test.vhd

set FRAC_BW 22
set i 0

set top($i) cfg_cordic
set generic_args($i) [list FRAC_BW $FRAC_BW]
append generic_str($i) cordic "_" $FRAC_BW

incr i

set top($i) cfg_pwr2_based
set generic_args($i) [list FRAC_BW $FRAC_BW]
append generic_str($i) pwr2_based "_" $FRAC_BW

incr i

set top($i) cfg_pwr2_based_opt
set generic_args($i) [list FRAC_BW $FRAC_BW]
append generic_str($i) pwr2_based_opt "_" $FRAC_BW

incr i

set top($i) cfg_pwr2
set generic_args($i) [list FRAC_BW $FRAC_BW]
append generic_str($i) pwr2 "_" $FRAC_BW

incr i

