#!/bin/bash
#1130512為了開始存股，投資ETF型股票風險看起來比較小，所以開始建立相關基本資料的建檔，思路和原本的一樣，但ETF型分為季配、月配、半年配，股利的計算和原本股票不一樣，為了要長期投資觀察，我還是努力一下。
#1130512這個程式是為了建立基本資料庫，輸入資料檔，就會逐行去下載資料，再建立資料庫，功能很單純。
#1130514因為讀回來的資料有些許不同，所以修改了一些判斷的方式，比較能因應不同的情況。
etfstockdata(){
rm *.txtc
file=$1
while read line
do
#下載網路上的資料，並且整理，因為整理完的資料全在一行上，所以還要再處理。
wget -O $line.html https://histock.tw/stock/$line/%E9%99%A4%E6%AC%8A%E9%99%A4%E6%81%AF
cat $line.html |grep '<td class="b-b">' > t.txt
cat t.txt | sed s/'<tr>'//g|sed s/'<td>'//g |sed s/'\/tr'//g |sed s/'\/td'//g|sed s/'td class="date"'//g |sed s/'td class="b-b"'//g|sed s/'td style="display:none;"'//g|sed s/'tr class="alt-row"'//g|sed s/'<><>-<>-<>'//g >t1.txt
#y是現在的西元年，ly是十年之前的西元年，取太多年也沒用。
y=$(date +%Y)
ly=$(echo $y-10|bc -l)
#j是我觀察取回的資料，我要的西元年是第4或第5個欄位，所以這邊有一個判斷式，如果sy不存在，則由改成第5欄開始。ck是用來判斷跳離無窮迴圈的指標。
j=4
ck=1
sy=$(cat t1.txt|cut -d ">" -f $j|cut -d "<" -f 1|cut -d ">" -f 1)
#echo $sy,$j,$ly,$y
if [[ $sy ]]
then
	:
#	echo "no"
else
	j=5
#	echo $j
fi
#因為不知道到底多少年的資料，所以要用無窮迴圈的方式來處理資料。
until [ $ck == 0 ]
do
	sy=$(cat t1.txt|cut -d ">" -f $j|cut -d "<" -f 1|cut -d ">" -f 1)
	#echo $j,$sy,$ly,$y
	#這邊要再次確認j是否有發揮功能，有正確讀入，不然就要結束。
	if [[ $sy ]]
	then
	#這邊判斷一下十年內的資料，且讀進來的sy是數字，不是什麼亂七八糟符號，表示有讀到正確的資料。 
		if [ $sy -ge $ly ] && [[ $sy =~ ^[0-9]+$ ]]
		then
			echo $(cat t1.txt|cut -d ">" -f $j)$(cat t1.txt|cut -d ">" -f $(echo $j+3|bc -l))$(cat t1.txt|cut -d ">" -f $(echo $j+6|bc -l))$(cat t1.txt|cut -d ">" -f $(echo $j+7|bc -l))$(cat t1.txt|cut -d ">" -f $(echo $j+8|bc -l)) >> $line.txtc
			ck=$(echo $ck+1|bc -l)
			#判斷下一個j是否在正確位置上，因為我觀察回來的資料，有二種間隔的方式，所以我先設一種，如果讀回來的值不正確，就改另一種。
			jc=$(cat t1.txt|cut -d ">" -f $(echo $j+18|bc -l)|cut -d "<" -f 1|cut -d ">" -f 1 )
			#echo "jc=$jc"
			if [[ $jc ]]
			then
				j=$(echo $j+18|bc -l)
			else
				j=$(echo $j+19|bc -l)
			fi
			#if [[ $((ck % 2)) == 0 ]]; then
			#	j=$(echo $j+18|bc -l)
			#	echo $ck,$j
			#else
			#	j=$(echo $j+19|bc -l)
			#	echo $ck,$j
			#fi
		else
			ck=0
			#echo $ck
		fi
	else
		ck=0
		echo $line,"some thing wrong"
	fi
done
done < $file
#rm *.txt *.html
}
etfstockdata $1
