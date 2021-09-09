source ../build_import.tcl
foreach key [array names top] {   
    set generic ""
    
    if {[array exists generic_args] && [info exists generic_args($key)]} {
        foreach {arg_name arg_val} $generic_args($key) {
            append generic -generic " " $arg_name=$arg_val " " 
        }        
    }

    if {![array exists power_testbench] || ![info exists power_testbench($key)]} {        
        set power_testbench($key) "power_testbench.vhd"
    }

    eval synth_design -top $top($key) -part [lindex $argv 0] $generic    
    
    create_clock -period 10.0 -name clk [get_ports clk]

    write_vhdl -mode funcsim -force ../.netlists/$generic_str($key).vhd
    
    exec xvhdl ../../utils/fixed_pkg_2008.vhd
    exec xvhdl ../../utils/rng.vhd
    exec xvhdl ../.netlists/$generic_str($key).vhd
    exec xvhdl ../$power_testbench($key)

    eval exec xelab -debug typical testbench -s top_sim $generic
    set ::env(SAIF_FILE) ../.saif/$generic_str($key)
    eval exec xsim top_sim -tclbatch ../../power_sim_opt.tcl
    puts "Finished power simulation of $generic"


    read_saif ../.saif/$generic_str($key).saif
    
    opt_design
    place_design
    route_design

    report_power -file ../.reports/power_$generic_str($key).rpt
    report_timing_summary -file ../.reports/timing_$generic_str($key).rpt
    report_utilization -file ../.reports/utilization_$generic_str($key).rpt

    puts "Finished build of $generic"
}