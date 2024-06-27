#!/bin/bash
#
matchm(){
	file=$1
	while read line
	do
		match=$(cat $2|grep $line)	
		coun=$(echo $match|wc -L)
		if [ $coun = 0 ]
		then
			:
		else
			sed -i s/$line//g $1
			sed -i '/^$/d' $1
		fi
	done < $file
}
matchm $1 $2
