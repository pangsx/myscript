#!/bin/bash
makedb(){
echo "makedb now"
#依選擇的參數來決定建立何資料庫
	case $6 in
		1)
			(cat $1 |grep "$2"|cut -d '>' -f 2|cut -d '<' -f 1) > period.db
			for i in {1..7}
			do
				(cat $1 |grep "$4$i"|cut -d '>' -f 2|cut -d '<' -f 1) > $i.db
			done

			output=happyf.txt
			;;
		2)
			(cat $1 |grep "$2"|cut -d '>' -f 3|cut -d '<' -f 1) > period.db
			for i in {1..6}
			do
				(cat $1 | grep "$4$i"| cut -d '>' -f 3 | cut -d '<' -f 1) > $i.db
			done
			(cat $1 | grep "$4_"| cut -d '>' -f 4 | cut -d '<' -f 1) > 7.db
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
			until [ $i = 10 ]
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
			until [ $i = 10 ]
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
