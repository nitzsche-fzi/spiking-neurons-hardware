exec xvhdl ../../utils/fixed_pkg_2008.vhd
exec xvhdl ../../utils/neuron_log.vhd
exec xvhdl ../../pwr_pkg/pwr.vhd
exec xvhdl ../hodgkin_huxley.vhd
exec xvhdl ../testbench.vhd

set i 0

foreach I [list 0.5 1.0 2.0] {
    for {set FRAC_BW 16} {$FRAC_BW <= 24} {incr FRAC_BW} {
        set generic_args($i) [list FRAC_BW $FRAC_BW I $I]
        append generic_str($i) $FRAC_BW "_" $I

        incr i
    }
}