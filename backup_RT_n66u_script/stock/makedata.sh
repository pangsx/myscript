#!/bin/sh
cd /
#cd /media/Data/workspace/stock/
cd /tmp/mnt/1110809/script/stock/
clear
rm db.txt
cp db.back db.txt
file=db.txt
while read line
do
	wget --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
		Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line-d.html \
		https://fund.bot.com.tw/Z/ZC/ZCC/ZCC_$line.DJHTM
	#sleep 30
	iconv -f BIG-5 -t UTF-8 $line-d.html > data2
	(cat data2 |grep t3n1 |cut -d '>' -f 2|cut -d '<' -f 1) > $line-di.txt
	sh summe.sh $line
done < $file
if [ -d "dividend" ]
then
	s=$s
else
	mkdir dividend
fi
mv -f ./*.txt ./dividend
if [ -d "stock" ]
then
	s=$s
else
	mkdir stock
fi
mv -f ./*.html ./stock
rm data?
rm *.txt
