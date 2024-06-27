#!/bin/bash
#1101209前一個版本運作是沒有問題的，但是因為我有建置龍江小幫手line提醒功能，所以我想重寫一個可以自動執行的版本，而且可以透過龍江小幫手告訴我那些股票在低價，可以關心一下了，不過還是要在原本的架構下建置。


#main
clear
cd /
cd /media/Data/workspace/stock/
rm db.txt
cp db.back db.txt

file=db.txt
while read line
do
	wget --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
	       	Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line.html \
		https://fund.bot.com.tw/Z/ZC/ZCA/ZCA_$line.DJHTM
	iconv -f big5 -t utf8 $line.html > data1
	price=$(cat data1| grep "td class="|head -n 9|tail -n 1|cut -d '>' -f 2|cut -d '<' -f 1)
	name=$(cat data1| grep $line|tail -n 1|cut -d '(' -f 1)
	echo $name > name.txt
	sed -i "s/[[:space:]]//g" name.txt
	name=$(cat name.txt)
	rm name.txt
	#1130507ETF類型的股票沒辦法用原網址下載資料，所以測試用新的網址來處理。
	#https://histock.tw/stock/financial.aspx?no=2324&t=2
	
	./summe.sh $line
	s=$(cat s.txt)
	s1=$(echo 'scale=2;'$s/10|bc -l)
	sl=$(echo 'scale=2;'$s1*16|bc -l)
	sok=$(echo 'scale=2;'$s1*17.85|bc -l)
	sh=$(echo 'scale=2;'$s1*20|bc -l)
#	echo $sl,$sok,$sh
	if [ $(echo "$price >= $sh"|bc -l) -eq 1 ] 
	then
		st="價太高了"
		echo -e $line,$name,$price,"\033[41;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[41;37m$st\033[0m" >> sol1.txt
	elif [ $(echo "$price < $sh"|bc -l) -eq 1 ] && [ $(echo "$price > $sok"|bc -l) -eq 1 ]
	then
		st="高於合理價"
		echo -e $line,$name,$price,"\033[43;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[43;37m$st\033[0m" >> sol1.txt
	elif [ $(echo "$price < $sok"|bc -l) -eq 1 ] && [ $(echo "$price > $sl"|bc -l) -eq 1 ]
	then
		st="在合理價以內"
		echo -e $line,$name,$price,"\033[44;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[44;37m$st\033[0m" >> sol1.txt
	elif [ $(echo "$price <= $sl"|bc -l) -eq 1 ]
	then
		st="低於低價"
		echo -e $line,$name,$price,"\033[42;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[42;37m$st\033[0m" >> sol1.txt
		./linep.sh $(date '+%Y%m%d'),$st,$line,$name,$price
		./lineh.sh $(date '+%Y%m%d'),$st,$line,$name,$price
	else
		echo -e $line,$name,$price,"\033[41;37msome thing wrong\033[0m"
		echo -e $line,$name,$price,"\033[41;37msome thing wrong\033[0m" >> sol1.txt
	fi
	ss=$(echo 'scale=2;'$s1*100/$price|bc -l)
	echo $line,$name,$price,$st,$sl,$sok,$sh,$ss% >> sol.txt
done < $file

mv sol1.txt $(date '+%Y%m%d')sol1.log
mv sol.txt $(date '+%Y%m%d')sol.log
if [ -d "dividend" ]
then
	s=$s
else
	mkdir dividend
fi
mv -u ./*.txt ./dividend

if [ -d "stock" ]
then
	s=$s
else
	mkdir stock
fi
mv -f ./*.html ./stock
rm data?
rm *.txt
