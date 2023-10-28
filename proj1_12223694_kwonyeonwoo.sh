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
		echo $ave | awk '{printf("%.5f",$1)}'
		;;
	4) 
		echo "4" ;;
	5)
		echo "5" ;;
	6)
		echo "6" ;;
	7)
		echo "7" ;;
	8)
		echo "8" ;;
	esac
echo ""
read -p "Enter your choice [ 1-9 ] " choice
done
echo "Bye !"