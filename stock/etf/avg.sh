#!/bin/bash
#1130513原本是要寫一個算平均的程式，但寫著寫著就變成把先前的etfstockdata.sh的結果整理成新的資料檔的形式了，邊寫邊想果然是不太好，不過反正整理好了，也就先這樣吧。
#1130515把平均的功能完成，可以回到主程式努力了。
avg(){
	y=$(date +%Y)
	sy=$(cat $1|head -n 1|cut -d '<' -f 1)
	ly=$(cat $1|tail -n 1|cut -d '<' -f 1)
	s=$(echo $sy-$ly|bc -l)
	#因應不同形式配息，所以這邊要針對每年的變結果分開來處理，再平均起來，今年的部分也要算，所以i從0開始
	for i in $(seq 0 $s)
	do
		cat $1|grep $(echo $sy-$i|bc -l) > temp.bb
		file=temp.bb
		#sc股票股利,da現金股利,ea殖率利
		sca=0
		da=0
		ea=0
		#這二個變數是用來計數算平均用的
		m=0
		n=0
		while read line
		do
			sc=$(echo $line |cut -d '<' -f 3)
			sca=$(echo $sca+$sc|bc -l)
			d=$(echo $line |cut -d '<' -f 4)
			da=$(echo $da+$d|bc -l)
			e=$(echo $line |cut -d '<' -f 5|cut -d '%' -f 1)
			#因為殖利率有的時候沒算出來，所以這邊要判斷一下變數e是否存在，不存在的話，要定義其為零，不然會整個不能運算
			if [[ $e ]]
			then 
			:
			else
			e=0
			((n++))
			fi
			ea=$(echo $ea+$e|bc -l)
			((m++))
		done < $file
		sold=$(echo 'scale=2;' $da/$m|bc -l)
		m1=$(echo $m-$n| bc -l)
		sole=$(echo 'scale=2;' $ea/$m1|bc -l)
		echo $(echo $sy-$i|bc -l),$sca,$sold,$sole% >> $1b
		rm *.bb
	done
	#1130515這一段才開始做平均，之前只是在把不同年度的平均起來
	solc=0
	#這邊在判斷平均幾年，ny就是發了多少年的股利的次數，因為最多用十年來統計，多了也沒用，所以最高就到十年。
	yy=$(cat $1b| cut -d "," -f 3)
	ny=$(echo "${yy[@]}"|tr ' ' '+' |wc -l)
	if [ $ny -gt 10 ]
	then
	ny=10
	else
	:
	fi
	#判斷完了以後就把要的部分於到暫存檔內
	cat $1b| head -n $ny > temp.pp
	#弄迴圈加總合吧，沒有簡單的方法
	file2=temp.pp
	while read line2
	do
	te=$(echo $line2|cut -d "," -f 3)
	#這邊要判斷一下te到底有沒有值，因為有的時候會斷掉，發不出股利，這點要注意
	if [[ $te ]]
	then
	:
	else
	te=0
	note="y"
	fi
	solc=$(echo $solc+$te| bc -l)
	#echo $te,$solc,$ny	
	done < $file2
	echo $solc,$ny,$note > $1c
	rm *.pp
}
avg $1
