read_vhdl ../../utils/fixed_pkg_2008.vhd
read_vhdl ../izhikevich.vhd

set i 0

foreach FRAC_BW [list 10 16] {
    set top($i) cfg_standard_izhikevich
    set generic_args($i) [list FRAC_BW $FRAC_BW]
    append  generic_str($i) standard "_" $FRAC_BW

    incr i
}

foreach FRAC_BW [list 8 16] {
    set top($i) cfg_simplified_izhikevich
    set generic_args($i) [list FRAC_BW $FRAC_BW]

    set power_testbench($i) "power_testbench_simplified.vhd"

    append generic_str($i) simplified "_" $FRAC_BW

    incr i
}