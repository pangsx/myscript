#!/bin/bash
#1130628


#main
clear
cd /
cd /media/Data/workspace/stock/etf/
rm db.txt
cp dbetf.back db.txt
file=db.txt
while read line
do
	wget -q --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
		Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line.html \
		https://histock.tw/stock/$line
	
	mv $line.html data1
	price=$(cat data1| grep og:description | cut -d "," -f 2 | cut -d " " -f 3)
	name=$(cat data1| grep og:description | cut -d "(" -f 1 | cut -d "\"" -f 6)
	echo $name > name.txt
	sed -i "s/[[:space:]]//g" name.txt
	name=$(cat name.txt)
	rm name.txt
	d=$(date +%Y%m%d)
	echo $d,$line,$name,$price >>record.tx
done < $file
mv -f ./*.html ./stock
rm data?
rm *.txt

