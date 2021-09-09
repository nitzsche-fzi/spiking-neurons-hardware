read_vhdl ../../utils/fixed_pkg_2008.vhd
read_vhdl ../../pwr_pkg/pwr.vhd
read_vhdl ../hodgkin_huxley.vhd

set i 0    

foreach FRAC_BW [list 16 24] {
    set top($i) hodgkin_huxley    
    set generic_args($i) [list FRAC_BW $FRAC_BW]
    append generic_str($i) $FRAC_BW

    incr i
}