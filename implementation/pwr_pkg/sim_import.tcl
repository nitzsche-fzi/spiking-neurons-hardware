exec xvhdl ../../utils/fixed_pkg_2008.vhd
exec xvhdl ../../utils/neuron_log.vhd
exec xvhdl ../pwr.vhd
exec xvhdl ../exp_test.vhd
exec xvhdl ../testbench.vhd

set i 0
foreach FRAC_BW [list 22] {        
    set generic_args($i) [list FRAC_BW $FRAC_BW]
    append generic_str($i) $FRAC_BW

    incr i
}