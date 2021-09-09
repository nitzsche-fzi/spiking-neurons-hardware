if [ -d "$1" ]; 
then
cd $1
mkdir -p .plots
mkdir -p .metrics
python eval.py "${@:2}"
cd ..
fi