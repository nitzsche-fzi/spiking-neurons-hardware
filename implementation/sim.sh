if [ -d "$1" ]; 
then
    mkdir -p $1/.tmp
    mkdir -p $1/.output
    cd $1/.tmp
    vivado -mode batch -source ../../sim.tcl -tclargs "${@:2}"
    cd ../..
fi
