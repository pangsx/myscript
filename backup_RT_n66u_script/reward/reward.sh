#!/bin/sh
#!/bin/sh
#對獎的主程函數
reward(){
	echo "now reward $1"
	if [ $1 = "happy1.txt" ]
	then
		g=happyf.txt
		sp=8
		output=solh.db
		notyet=notyeth.db
	elif [ $1 = "big1.txt" ]
	then
		g=bigf.txt
		sp=49
		output=solb.db
		notyet=notyetb.db
	else
		:
	fi
	while read line
	do
		sol=0
		priod=$(echo $line | cut -d "," -f 1)
		goat=$(cat $g |grep -w $priod)
		if [ -n "$goat" ]
		then
			#for i in $(seq 3 1 7)
			i=3
			until [ $i = 9 ]
			do
				a=$(echo $line | cut -d "," -f $i)
				a=$(printf "%02d\n" $a)
				ch=$(echo $goat |cut -d "^" -f 2 |cut -c 0-17| grep -w "$a")
				#echo $i,$a,$ch
				if [ -n "$ch" ]
				then
					sol=$(echo "$sol+1" | bc -l)
				else
					:
				fi
				i=$(echo "$i+1"| bc -l)
			done
			if [ $sp = 8 ]
			then
				a=$(echo $line | cut -d "," -f 9)
				a=$(printf "%02d\n" $a)
				ss=$(echo $goat |cut -d "," -f 8 | grep -w "$a")
				#echo $ss,$a,$line
				if [ -n "$ss" ]
				then
					sps=1
				else
					sps=0
				fi

			else
				a=$(echo $goat | cut -d "," -f 8)
				ss=$(echo $line | grep -w $a)
				#echo $ss,$a,$goat
				if [ -n "$ss" ]
				then
				sps=1
				#sol=$(echo "$sol-1" | bc -l)
				else
				sps=0
				fi
			fi
			echo $line,$sol,$sps >> $output
		else
			echo $line >> $notyet
		fi
	done < $1
}
reward $1
