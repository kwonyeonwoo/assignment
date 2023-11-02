#! /bin/bash


echo "--------------------------
User Name: kwonyeonwoo
Student Number: 12223694
[ MENU ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item'
3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'
4. Delete the 'IMDb URL' from 'u.item'
5. Get the data about users from 'u.user'
6. Modify the format of 'release date' in 'u.item'
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"
read -p "Enter your choice [ 1-9 ] " choice
while [ $choice -ne 9 ]
do
	echo ""
	case $choice in
	1)
		read -p "Please enter 'movie id' (1~1682): " mid
		echo ""
		cat u.item | awk -F \| -v id=$mid '$1==id {print $0}'
		;;
	2)
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" decision
		if [ "$decision" = "y" ]
		then
		echo ""
		mid=$(cat u.item | awk -F \| '$7=="1"{print $1}')
		for var in $( seq 1 10 )
		do
			index=$(echo $mid | awk -v a=$var '{print $a}')
			echo -n $index" "
			cat u.item | awk -F \| -v id=$index '$1==id {print $2}'
		done
		fi
		;;
	3)
		read -p "Please enter the 'movie id' (1~1682): " mid
		echo ""
		echo -n "average rating of $mid: "
		score=$(cat u.data | awk -v id=$mid '$2==id {sum+=$3} END {print sum}')
		numcount=$(cat u.data | awk -v id=$mid '$2==id {count+=1} END {print count}')
		ave=$(echo "$score/$numcount" | bc -l)
		echo $ave | awk '{printf("%.5f",$1)}' | grep -o '.*[1-9]'
		echo ""
		;;
	4) 
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) : " decision
		if [ "$decision" = "y" ]
		then
			echo ""
			sed -e 's/http.*)//g' -ne '1,10p' u.item	
		fi
	       	;;
	5)
		read -p "Do you want to get the data about users from 'u.user'?(y/n) : " decision
		if [ "$decision" = "y" ]
		then
			echo ""
			sed -E -ne 's/([0-9]+)(.|)([0-9]{2})(.|)([M|F])(.|)([a-z]+)(.|)([0-9]+)/user \1 is \3 years old \5 \7/g' -e 's/F/female/g' -e 's/M/male/g' -ne '1,10p' u.user
		fi
		;;
	6)
		read -p "Do you want to Modify the format of 'rlease data' in 'u.item'?(y/n) : " decision
		if [ "$decision" = "y" ]
		then
			echo ""
			sed -E -ne 's/Jan/01/g' -e 's/Feb/02/g' -e 's/Mar/03/g' -e 's/Sep/09/g' -e 's/Oct/10/g' -E -ne 's/([0-9]{2})(-)([0-9]{2})(-)([0-9]{4})/\5\3\1/' -ne '1673,1682p' u.item	
		fi
		;;
	7)
		read -p "Please enter the 'user id' (1~943) : " uid
		echo ""
		mid=$( sort -k2 -n u.data | awk -v uidCopy=$uid '$1==uidCopy{print $2}')
		list=$( sort -k2 -n u.data | awk -v uidCopy=$uid '$1==uidCopy{print $2,"|"}')
		echo $list
		echo ""
		for var in $( seq 1 10 )
		do 
			index=$(echo -n $mid | awk -v copy=$var '{print $copy}')
			mname=$(cat u.item | awk -F \| -v pos=$index '$1==pos{print $2}')
			echo $index " | " $mname
		done
		;;
	8)
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) : " decision
		if [ "$decision" = "y" ]
		then
		echo ""
		uid=$(cat u.user | awk -F \| '$2>=20 && $2<30 && $4=="programmer"{print $1}')
		for var in $uid
		do
			list+=$(cat u.data | awk -v uidx=$var '$1==uidx{print $0,","}')
		done
		for var in $( seq 1 1682 )
		do
			score=$(echo $list | awk -v midx=$var 'BEGIN {RS = ","} $2==midx{sum+=$3} END {print sum}')
			count=$(echo $list | awk -v midx=$var 'BEGIN {RS = ","} $2==midx{num++} END {print num}')
			if [ "$count" > "0" ]
			then
				ave=$(echo "$score/$count" | bc -l)
				echo -n $var " "
				echo $ave | awk '{printf("%.5f",$1)}' | grep -o '.*[1-9]'
			else
				continue
			fi
		done
		fi
		;;
	esac
echo ""
read -p "Enter your choice [ 1-9 ] " choice
done
echo "Bye !"
