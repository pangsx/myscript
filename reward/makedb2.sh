#!/bin/bash
#因為網站更新了，所以只好重寫新的資料庫整理
makedb(){
echo "makedb now"

#依選擇的參數來決定建立何資料庫
	case $6 in
		1)
			(cat $1 |grep "$2" |grep 第 |cut -d '>' -f 2|cut -d '<' -f 1) > period.db
			j=1
			for i in {2..14..2}
			do
				#echo $i,$j
				(cat $1 |grep $4|cut -d '>' -f $i|cut -d '<' -f 1) > $j.db
				#(cat $1 |grep $4|cut -d '>' -f $i|cut -d '<' -f 1) 
				((j++))
			done
			output=happyf.txt
			;;
		2)
			(cat $1 |grep "$2" |grep 第 | cut -d '>' -f 2|cut -d '<' -f 1) > period.db
			j=1
			for i in {2..14..2}
			do
				(cat $1 |grep $4|cut -d '>' -f $i|cut -d '<' -f 1) > $j.db
				((j++))
			done
			output=bigf.txt
			;;
		*)
			echo "some thing wrong"
			;;
	esac
	(cat $1 |grep "$3"|cut -d '>' -f 2|cut -d '<' -f 1) > day.db
	i=1
	#case1是己有下載過資料庫的情形，所以要判斷一下，只加入新的資料，case2是從無到有。
	case $5 in
		1)
			until [ $i = 20 ]
			do
				a=$(sed -n "$i"p period.db)
				check=$(cat $output | grep "$a"| head -n 1|cut -d ',' -f 1)
				if [ -n "$check" ]
				then
					((i++))
				else
					b=$(sed -n "$i"p day.db)
					c=$(sed -n "$i"p 1.db)
					d=$(sed -n "$i"p 2.db)
					e=$(sed -n "$i"p 3.db)
					f=$(sed -n "$i"p 4.db)
					g=$(sed -n "$i"p 5.db)
					h=$(sed -n "$i"p 6.db)
					j=$(sed -n "$i"p 7.db)
					echo $a,$b'^'$c,$d,$e,$f,$g,$h,$j >> tempp.txt			
					((i++))
				fi
			done
			;;
		2)
			until [ $i = 20 ]
			do
				a=$(sed -n "$i"p period.db)
				b=$(sed -n "$i"p day.db)
				c=$(sed -n "$i"p 1.db)
				d=$(sed -n "$i"p 2.db)
				e=$(sed -n "$i"p 3.db)
				f=$(sed -n "$i"p 4.db)
				g=$(sed -n "$i"p 5.db)
				h=$(sed -n "$i"p 6.db)
				j=$(sed -n "$i"p 7.db)
				echo $a,$b'^'$c,$d,$e,$f,$g,$h,$j >> tempp.txt
				((i++))
			done
			;;
	esac
	rm *.db
	return 1
}
makedb $1 $2 $3 $4 $5 $6
