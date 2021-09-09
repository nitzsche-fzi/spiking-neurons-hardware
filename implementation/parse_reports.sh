if [ -d "$1" ]; 
then
cd $1
python ../parse_reports.py
cd ..
fi