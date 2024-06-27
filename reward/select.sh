#!/bin/bash
#1130303這是用來判斷有沒有對過獎的函數，可以把不能對獎且對獎檔內沒有的留下來，才不會一直重複對，重複通知。
selectt(){
	if [ $1 = big2.txt ]
	then
		output=big1.txt
		checkfile=bigf.txt
	else
		echo "check input1"
	fi
	if [ $1 = happy2.txt ]
	then 
		output=happy1.txt
		checkfile=happyf.txt
	else
		echo "check input2"
	fi
	file=$1
	while read line
	do
		se=$(echo $line|cut -d "," -f 1)
		ca=$(cat $checkfile|grep "$se"|head -n 1)
		cb=$(cat $output|grep $line)
		#echo $se,$ca,$cb
		if [ -z $ca ]
		then
			if [ -z $cb ]
			then
				echo $line >> $output
			else
				:
			fi
		else
		:
		fi
	done < $file
}
selectt $1
