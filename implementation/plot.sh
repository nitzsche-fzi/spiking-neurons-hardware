if [ -d "$1" ]; 
then
cd $1
python plot.py
cd ..
fi