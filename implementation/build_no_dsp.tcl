source ../build_import.tcl
foreach key [array names top] {   
    set generic ""
    
    if {[array exists generic_args] && [info exists generic_args($key)]} {
        foreach {arg_name arg_val} $generic_args($key) {
            append generic -generic " " $arg_name=$arg_val " " 
        }        
    }

    eval synth_design -top $top($key) -part [lindex $argv 0] $generic -max_dsp 0
    
    create_clock -period 10.0 -name clk [get_ports clk]
    
    opt_design
    place_design
    route_design

    report_utilization -file ../.reports/nodsputilization_$generic_str($key).rpt

    puts "Finished no dsp build of $generic"
}