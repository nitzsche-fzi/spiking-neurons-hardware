exec xvhdl ../../utils/fixed_pkg_2008.vhd
exec xvhdl ../../utils/neuron_log.vhd
exec xvhdl ../izhikevich.vhd
exec xvhdl ../testbench.vhd

set i 0

foreach I [list 2.0 4.0 6.0 9.0 12.0 16.0] {
    for {set FRAC_BW 5} {$FRAC_BW <= 16} {incr FRAC_BW} {        
        set generic_args($i) [list FRAC_BW $FRAC_BW I $I]
        append generic_str($i) 7 "_" $FRAC_BW "_" $I

        incr i
        
        set generic_args($i) [list FRAC_BW $FRAC_BW I $I STANDARD false]
        append generic_str($i) 7 "_" $FRAC_BW "_" $I

        incr i
    }
}