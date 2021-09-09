read_vhdl ../liaf.vhd

set DW [lindex $argv 1]

set i 0

foreach {DW} [list 9 16] {
    set top($i) liaf
    set generic_args($i) [list DATA_WIDTH $DW]
    append generic_str($i) $DW

    incr i
}