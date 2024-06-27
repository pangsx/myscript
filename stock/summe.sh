#!/bin/bash

summe(){
	file=./dividend/$1.txt
	s=0
	i=1
	while read line2
	do
		if [ $i = 7 ] || [ $i = 15 ] || [ $i = 23 ] || [ $i = 31 ] || [ $i = 39 ] || \
		       [ $i = 47 ] || [ $i = 55 ] || [ $i = 63 ] || [ $i = 71 ] || [ $i = 79 ]  
		then
		s=$(echo $s+$line2|bc)
		else
		line2=$line2
		fi
		((i++))
	done < $file
	echo $s > s.txt
	return 1		
}
summe $1-di

