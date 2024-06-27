#!/bin/sh
#!/bin/sh
#這應該是把對過的期數去除的函數，有點忘了
matchm(){
	file=$1
	while read line
	do
		match=$(cat $2|grep $line)
		coun=$(echo $match|wc -L)
		#echo $match,$coun
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
