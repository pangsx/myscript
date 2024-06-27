#!/bin/bash
happyreward(){
	#說明去參考bigreward.sh思路一樣，我沒興趣打二次。
#echo "this is happyrewrad"
	if [ $# != 8 ]
	then
		echo "要輸入數期和號碼才能對獎哦，檢查一下吧"
		exit 2
	fi
	an=$(cat happyf.txt | grep "$1" | head -n 1)
 	echo $an > temp.dc
 	if [  -z $an ]
	then
	#worksp  $1 $2 $3 $4 $5 $6 $7 $8
	bonus="notyet"
	else
	worksp  $1 $2 $3 $4 $5 $6 $7 $8
		#bonus="notyet"
	fi
	echo $bonus > temp.db
}

worksp(){
		(cat temp.dc | cut -d '^' -f 2) >t1.dc
		sp=$(cat temp.dc |cut -d '^' -f 2|cut -d ',' -f 7)
		if [ $8 = $sp ]
		then
			countre $1 $2 $3 $4 $5 $6 $7 $8
			case $countsol in
				1)
					echo "中100元，辛苦囉"
					bonus=100
					;;
				2)
					echo "200元，回本啦"
					bonus=200
					;;
				3)
					echo "中400元啦～～"
					bonus=400
					;;
				4)
					echo "中4000元，不錯哦"
					bonus=4000
					;;
				5)
					echo "中15萬元，爽～～～"
					bonus=15000
					;;
				6)
					echo "出運啦～～～～中頭獎啦～～～"
					bonus="bigone"
					;;
				0)
					echo "sorry"
					bonus=0
					;;
			esac
		else
			countre $1 $2 $3 $4 $5 $6 $7 $8
			case $countsol in
				3)
					echo "中100元～～～"
					bonus=100
					;;
				4)
					echo "中800元，真不錯"
					bonus=800
					;;
				5)
					echo "中20,000元，哦耶～～～"
					bonus=20,000
					;;
				6)
					echo "中大獎啦～～～但我好想哭哦～～～"
					bonus="bigtwo"
					;;
				*)
					echo "sorry"
					bonus=0
					;;
			esac
		fi
}




countre(){
	temp=$(echo $2,$3,$4,$5,$6,$7)
	countsol=0
	i=1
	for i in {1..6}
	do
		#1101124因為二區的號碼會重複，所以對獎的部分把二區刪掉，避免誤會，反正二區有沒有中的判斷在前面，這邊只處理一區的部分。
		t12=$(cat t1.dc)
		t12=${t12:0:17}
		checkco=$(echo $t12|grep "$(echo $temp| cut -d ',' -f $i)")
		if [ -n "$checkco" ]
		then
			((countsol++))
			((i++))
		else
			((i++))
		fi
	done
}
happyreward $1 $2 $3 $4 $5 $6 $7 $8 
rm *.dc
