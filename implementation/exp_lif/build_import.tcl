read_vhdl ../../utils/fixed_pkg_2008.vhd
read_vhdl ../../pwr_pkg/pwr.vhd
read_vhdl ../exp_lif.vhd

set i 0

foreach FRAC_BW [list 5 7 16] {
    set top($i) ExpLIF
    set generic_args($i) [list CORDIC false FRAC_BW $FRAC_BW]
    set generic_str($i) pwr2_$FRAC_BW

    incr i
}

foreach FRAC_BW [list 8 16] {
    set top($i) ExpLIF
    set generic_args($i) [list CORDIC true FRAC_BW $FRAC_BW]
    set generic_str($i) std_$FRAC_BW

    incr i
}

foreach FRAC_BW [list 5 7 16] {
    set top($i) ExpLIF
    set generic_args($i) [list CORDIC false POWER2_BASE true FRAC_BW $FRAC_BW]
    set generic_str($i) pwr2_b2_$FRAC_BW

    incr i
}
