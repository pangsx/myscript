#!/bin/sh
#!/bin/sh
#
sol(){
	if [ $1 = "solh.db" ]
	then
		ca=1
		x1=100;x2=200;x3=400;x4=4000;x5=15000;x6=中頭彩;
		y1=100;y2=800;y3=20000;y4=哭吧;
		m1=10;m2=11
	elif [ $1 = "solb.db" ]
	then
		ca=2
		x1=0;x2=400;x3=1000;x4=10000;x5=百萬;x6=不可能;
		y1=400;y2=2000;y3=50000;y4=中頭彩;
		m1=9;m2=10
	else
		:
       	fi
	while read line
	do
		priod=$(echo $line | cut -d "," -f 1)
		s=$(echo $line | cut -d "," -f $m1)
		sp=$(echo $line | cut -d "," -f $m2)
		echo $1,$s,$sp
		if [ $sp = 1 ] && [ $ca = 2 ]
		then
			s=$(echo "$s-1" | bc -l)
		else
			:
		fi

		if [ $sp = 1 ]
		then
			case $s in
				1)
					echo "中$x1元，辛苦囉"
					bonus=$x1
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				2)
					echo "$x2元，回本啦"
					bonus=$x2
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				3)
					echo "中$x3元啦～～"
					bonus=$x3
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				4)
					echo "中$x4元，不錯哦"
					bonus=$x4
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				5)
					echo "中$x5元，爽～～～"
					bonus=$x5
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				6)
					echo "出運啦～～～～$x6啦～～～"
					bonus=$x6
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				0)
					echo "sorry"
					bonus=0
					;;
			esac
		else
			case $s in
				3)
					echo "中$y1元～～～"
					bonus=$y1
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				4)
					echo "中$y2元，真不錯"
					bonus=$y2
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				5)
					echo "中$y3元，哦耶～～～"
					bonus=$y3
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				6)
					echo "中大獎啦～～～～～"
					bonus=$y4
					sh linep.sh "$priod,$s,$sp,$bonus"
					;;
				*)
					echo "sorry"
					bonus=0
					;;
			esac
		fi
	done < $1
}
sol $1
