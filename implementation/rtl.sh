mkdir -p $1/.tmp
mkdir -p $1/.reports
cd $1/.tmp
vivado -mode batch -source ../../rtl.tcl
cd ../..