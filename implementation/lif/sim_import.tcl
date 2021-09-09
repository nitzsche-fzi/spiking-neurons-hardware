exec xvhdl ../../utils/neuron_log.vhd
exec xvhdl ../liaf.vhd
exec xvhdl ../testbench.vhd

set i 0

for {set DW 5} {$DW <= 16} {incr DW} {
    foreach I [list 1 1.03125 1.0625 1.1875 1.25 1.5] {        
        set generic_args($i) [list DW $DW I $I]
        append generic_str($i) $DW "_" $I

        incr i
    }
}