exec xvhdl ../../utils/fixed_pkg_2008.vhd
exec xvhdl ../../utils/neuron_log.vhd
exec xvhdl ../../pwr_pkg/pwr.vhd
exec xvhdl ../ad_ex.vhd
exec xvhdl ../testbench.vhd

set i 0

foreach I [list 0.75 1.0 1.75 2.25 3.25 4.0] {
    for {set FRAC_BW 2} {$FRAC_BW <= 16} {incr FRAC_BW} {        
        set generic_args($i) [list FRAC_BW $FRAC_BW I $I]
        append generic_str($i) $FRAC_BW "_" $I

        incr i
    }
}