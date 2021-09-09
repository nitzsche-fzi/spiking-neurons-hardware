if [ -d "$1" ]; 
then
cd $1
python3 eval.py
cd ..
fi