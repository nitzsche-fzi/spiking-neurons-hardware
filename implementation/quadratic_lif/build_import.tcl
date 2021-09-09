read_vhdl ../../utils/fixed_pkg_2008.vhd
read_vhdl ../quadratic_lif.vhd

set i 0

foreach FRAC_BW [list 7 16] {
    set top($i) QuadraticLIF
    set generic_args($i) [list FRAC_BW $FRAC_BW]
    append generic_str($i) $FRAC_BW

    incr i
}