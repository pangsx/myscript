#!/bin/sh
#這是建立對獎資料庫的函數
makedb(){
echo "make database $1"
#這一區定義一些特徵值，以利後續從下載回來的網頁資料中，拮取需要的部分
if [ "$1" = "happy.db" ]
then
	s1=SuperLotto638Control_history1_dlQuery_DrawTerm
	s2=SuperLotto638Control_history1_dlQuery_Date
	s3=SuperLotto638Control_history1_dlQuery_SNo
	m1=8
	m2=2
	output=happyf.txt
elif [ "$1" = "big.db" ]
then
	s1=Lotto649Control_history_dlQuery_L649_DrawTerm
	s2=Lotto649Control_history_dlQuery_L649_DDate_
	s3=Lotto649Control_history_dlQuery_No
	#Lotto649Control_history_dlQuery_SNo
	m1=7
	m2=3
	output=bigf.txt
else
	echo "check input"
	sh linep.sh $1
	exit
fi

#判斷輸出檔是否存在，不存在就建立一個
if [ -e $output ]
then
:
else
touch $output
fi
#拮取期數
(cat $1 |grep "$s1"|cut -d '>' -f $m2|cut -d '<' -f 1) > period.db

#拮取各期獎號
#for i in $(seq 1 $m1)
i=1
until [ $i = $m1 ]
do
	(cat $1 |grep "$s3$i"|cut -d '>' -f $m2|cut -d '<' -f 1) > $i.db
	i=$(echo "$i+1"|bc -l)
done
#大樂透多一個特別號要去拮取
if  [ "$1" = "big.db" ]
then
(cat $1 |grep "$s3"7|cut -d '>' -f 4|cut -d '<' -f 1) > 7.db
else
:
fi
#拮取日期
(cat $1 |grep "$s2"|cut -d '>' -f 2|cut -d '<' -f 1) > day.db

#建立奬號資料檔
#for i in $(seq 1 10)
i=1
until [ $i = 10 ]
do
	a=$(sed -n "$i"p period.db)
	check=$(cat $output | grep "$a"| head -n 1|cut -d ',' -f 1)
	if [ -n "$check" ]
	then
		i=$(echo "$i+1" | bc -l)
		
	else
		b=$(sed -n "$i"p day.db)
		c=$(sed -n "$i"p 1.db)
		d=$(sed -n "$i"p 2.db)
		e=$(sed -n "$i"p 3.db)
		f=$(sed -n "$i"p 4.db)
		g=$(sed -n "$i"p 5.db)
		h=$(sed -n "$i"p 6.db)
j=$(sed -n "$i"p 7.db)

		#if [ "$1" = "big.db" ]
		#then
		#	j=$(sed -n "$i"p 7.db)
			echo $a,$b'^'$c,$d,$e,$f,$g,$h,$j >> $output
		#else
		#	echo $a,$b'^'$c,$d,$e,$f,$g,$h >> $output

		#fi
		i=$(echo "$i+1" | bc -l)
	fi
done
return 1

}
makedb $1
