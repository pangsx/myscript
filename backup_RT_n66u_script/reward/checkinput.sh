#!/bin/sh
checkinput(){
	echo "now check $1"
	if [ "$1" = "happy2.txt" ]
	then
		m=7
		n=38
		sp=8
	elif [ "$1" = "big2.txt" ]
	then
		m=7
		n=49
		sp=49
	else
		echo "check input"
		sh linep.sh $1
	fi
	while read line
	do
		priod=$(echo $line | cut -d "," -f 1)
		i=3
		#for i in $(seq 3 1 8)
		until [ $i = 8 ]
		do
			a=$(echo $line|cut -d "," -f $i)
			if [ $a -le $n ]
			then
				:
			else
				echo "check input"
				echo $priod,$a >> error1.txt
				exit 2
			fi
			i=$(echo "$i+1" | bc -l)
		done
		a=$(echo $line|cut -d "," -f 9)
		if [ $sp = 8 ]
		then
			if [ -n $a ] && [ $a -le $sp ]
			then
				:
			else
			echo "check input sp"
			echo $priod,$sp >> error1.txt
			exit 2
			fi
		else
			:
		fi
	done < $1
	return 1
}
checkinput $1
