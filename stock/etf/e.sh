#!/bin/bash
#

# Function to check if a file exists
function check_file_exists() {
  if [[ ! -f "$1" ]]; then
    echo "Error: File '$1' does not exist!"
    exit 1
  fi
}


e(){
	clear
	cd /
	cd /media/Data/workspace/stock/etf/
	rm db.txt
	cp dbetf.back db.txt
	check_file_exists db.txt
	check_file_exists record.tx
	# Get today's date
	todayDate=$(date +%Y%m%d)
	s1=$(cat record.tx|grep $todayDate)
	if [ $s1 -n ]
	then
		:
	else
		echo "error1"
		exit
	fi
	i=$1
	file=db.txt
	while read line
	do
		p1=$(cat record.tx|grep "$todayDate"|grep "$line"|uniq)
		until [ $i == 0 ]
		do
			dx=$(echo $todayDate-$i| bc -l)
			px=$(cat record.tx|grep "$dx"|grep "$line"|uniq)
			if [ $p1 -gt $px ]
			then
				count=$(echo $count+1|bc -l)
				ps=$(echo $p1-$px|bc -l)
			else
				:
			fi
			(($i--))
		done
		if [ $count == $1 ]
		then
			echo $todayDate,$line,$count,$ps
		else
			:
		fi
	done < $file
}
e $1

