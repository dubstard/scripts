#!/bin/bash
#Get yesterday's date as $d
d=$(date -d "yesterday 13:00" '+%Y-%m-%d')
echo "$d"
#read the banks.txt file line by lineand feed it to the script
cat banks.txt | while read i; do
(
echo "Checking for TLDs related to $i for past date $d"
	python hnrd.py -f $d -s $i
		sleep 4
)
done
