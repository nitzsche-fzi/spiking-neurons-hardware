mkdir -p $1/.tmp
mkdir -p $1/.reports
mkdir -p $1/.saif
mkdir -p $1/.netlists

cd $1/.tmp
vivado -mode batch -source ../../build.tcl -tclargs xczu9eg-ffvb1156-2-e "${@:2}"
cd ../..