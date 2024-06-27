#!/bin/bash
#
cd /
cd /media/Data/workspace/stock/
wget -q --no-check-certificate "https://histock.tw/stock/public.aspx" -O "1.html"
cat 1.html |grep 'target="_blank"'|cut -d ';' -f 2|cut -d '<' -f 1 > name.txt
cat 1.html |grep '~'|cut -d '~' -f 1|cut -d '/' -f 1 > mon.txt
cat 1.html |grep '~'|cut -d '~' -f 1|cut -d '/' -f 2 > day.txt
tmon=$(date '+%m')
tday=$(date '+%d')
file=mon.txt
while read line
do
	if [ $line = $tmon ]
	then
		((i++))
	else
		:
	fi
done < $file
for j in $(seq 1 $i)
do
	cday=$(cat day.txt |head -n $j | tail -n 1)
	if [ $cday = $tday ]
	then
		sname=$(sed -n "$jp" name.txt)
		./linep.sh $sname可以抽哦，快上。
		./lineh.sh $sname可以抽哦，快上。
	else
		:
	fi
done
rm *.txt *.html
