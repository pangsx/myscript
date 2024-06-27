#!/bin/bash
readdb(){
echo "readdb now"
#這是從對獎檔逐行讀入要對的資料，再去呼叫對獎腳本。
file=$1
while read line || [[ -n ${line} ]]
do
	case $2 in
		1)
			j=0
			for i in {1..9}
			do
				reward[$j]=$(echo $line|cut -d ',' -f "$i")
				#這以下是要幫輸入的數字補0的，因為電腦1和01是不一樣的東西，所以我輸入的時候懶得打0，就在這加一段，幫我打零。
				if [ $i -gt 2 ]
				then 
					cc=${reward[$j]}
					if [ $cc -lt 10 ] && [ ${#cc} -eq 1 ]
					then
						reward[$j]=0$cc
					else
						:
					fi
				else
					:
				fi
				j=i
			done
			#echo "${reward[@]}"
			okk=okh.txt
			#這下面依威力彩的遊戲規則，確認輸入的數值符不符合遊戲規則。
			if [ ${reward[9]} -le 8 ] && [  -n ${reward[9]} ]
			then
				for i in {3..8}
				do
					if [ ${reward[$i]} -le 38 ] && [  -n ${reward[$i]} ]
					then
						:
					else
						echo "check input1"
					echo ${reward[@]}
						exit 2
					fi
				done
			else
				echo "check input2"
				exit 1
			fi
			#呼叫對獎腳本了，這邊矩陣數值的對應很奇妙，以下是用試誤法測出來正確輸出的方式，這部分我沒有想去弄懂，我己經弄太久了。
			./happyreward.sh ${reward[0]} ${reward[3]} ${reward[4]} ${reward[5]} ${reward[6]} ${reward[7]} ${reward[8]} ${reward[9]}
			;;
		2)
			j=0
			for i in {1..8}
			do
				reward[$j]=$(echo $line|cut -d ',' -f "$i")
				if [ $i -gt 2 ]
				then 
					cc=${reward[$j]}
					if [ $cc -lt 10 ] && [ ${#cc} -eq 1 ]
					then
						reward[$j]=0$cc
					else
						:
					fi
				else
					:
				fi
				j=i
			done	
			#echo "${reward[@]}"
			okk=okb.txt
			for i in {3..8}
			do
				if [ ${reward[$i]} -le 49 ] && [  -n ${reward[$i]} ]
				then
					:
				else
					echo "check input3"
	#				echo ${reward[@]}
					exit 2
				fi
			done
			./bigreward.sh ${reward[0]} ${reward[3]} ${reward[4]} ${reward[5]} ${reward[6]} ${reward[7]} ${reward[8]} ${reward[9]}
			;;
		*)
			echo "need select what do you want to reward."
			;;
	esac
       #這邊是把對獎成果和還不能對的期數做一簡單的整理。	
	bonus=$(cat temp.db)
	if [ $bonus = notyet ]
	then
		echo $line >> notyet.txt
	else
		echo $line,$bonus >> $okk
		#1101130加入line 通知我有沒有中獎的機制。
		if [ $bonus != 0 ]
			then
				./linep.sh $line中$bonus了 8525 16581303
			else
				:
			#	./linep.sh $line做功德了 8525 16581310
		fi
	fi
	#sed -i 1d $1
	rm temp.db
done < $file
if [  -f notyet.txt ]
then
	rm $1
	mv notyet.txt $1
else
	echo "work over"
fi
./linep.sh $(date '+%Y%m%d')_work_done
}
readdb $1 $2 
#1>&2 >> /dev/null
