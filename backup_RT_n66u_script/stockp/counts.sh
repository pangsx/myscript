#!/bin/sh
#
counto(){
	cat $2 | grep $1 > temp.d
	file=temp.d
	ca=0
	cb=0
	while read line
	do
		p=$(echo $line | cut -d ',' -f 2)
		c=$(echo $line | cut -d ',' -f 3)
		if [ $p = $3 ]
		then
			ca=$(echo $ca+$c|bc -l)
		else
			cb=$(echo $cb+$c|bc -l)
			
		fi
	done < $file
	echo $ca,$cb > sola.txt
	rm temp.d
	return 1
}
counto $1 $2 $3
