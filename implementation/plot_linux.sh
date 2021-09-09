if [ -d "$1" ]; 
then
cd $1
python3 plot.py
cd ..
fi