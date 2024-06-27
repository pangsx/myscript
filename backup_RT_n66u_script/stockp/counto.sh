#!/bin/sh
#
counto(){
	cat $2 | grep $1 > temp.d
	file=temp.d
	ca=0
	cb=0
	pa=0
	pb=0
	while read line
	do
		sel=$(echo $line | cut -d ',' -f 2)
		p=$(echo $line | cut -d ',' -f 3)
		c=$(echo $line | cut -d ',' -f 4)
		if [ $sel = $3 ]
		then
			tt=$(echo 'scale=2;'${p#-}*$c*1000|bc -l)
			ca=$(echo 'scale=2;'$ca+$tt+20|bc -l)
			pa=$(echo $pa+$p|bc -l)
		else
			t1=$(echo 'scale=2;'${p#-}*$c*1000|bc -l)
			t2=$(echo 'scale=2;'$t1*3/1000|bc -l)
			t3=$(echo 'scale=2;'$t1*0.1425/100|bc -l)
			cb=$(echo 'scale=2;'$cb+$t1-$t2-$t3|bc -l)
			pb=$(echo $pb+$p|bc -l)
		fi
	done < $file
	echo $pa,$ca,$pb,$cb > solution.txt
	rm temp.d
	return 1
}
counto $1 $2 $3
