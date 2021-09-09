source ../sim_import.tcl

set mode -R

if {[expr [llength $argv] != 0]} {
    set mode [lindex $argv 0]
}

foreach key [array names generic_str] {    
    if {[array exists generic_args] && [info exists generic_args($key)]} {
        set generic ""
        foreach {arg_name arg_val} $generic_args($key) {
            append generic --generic_top " " $arg_name=$arg_val " " 
        }        
    }
    eval exec xelab -debug typical testbench -s top_sim --generic_top "FILE_NAME=$generic_str($key).csv" --generic_top "DIR_NAME=../.output/" $generic
    eval exec xsim top_sim $mode
    puts "Finished simulation of $generic"
}

