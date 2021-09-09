source ../build_import.tcl
foreach key [array names top] {   
    set generic ""

    if {[array exists generic_args] && [info exists generic_args($key)]} {
        foreach {arg_name arg_val} $generic_args($key) {
            append generic -generic " " $arg_name=$arg_val " " 
        }        
    }
    
    eval synth_design -top $top($key) $generic -rtl
    start_gui
}