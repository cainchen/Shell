#!/bin/bash
clear
rm -f tmp 2&>1
i=0
while [ "${yn}" != "end" -a "${yn}" != "END" ]
do
	#while true; do
	i=$(($i+1))
	read -p "This $i times,Input first name(John): " name1
	read -p "This $i times,Input second name(Mary): " name2
	echo $name1 >> tmp
	echo $name2 >> tmp
	read -p "Please input end/END to stop this program: " yn
done
echo "Your input:"
awk '{for(i=1;i<=NF;i++)a[$i]++;}END{for(i in a){print i, a[i];}}' tmp
John=$(cat tmp |grep -i john | wc -l)
Mary=$(cat tmp |grep -i mary | wc -l)
echo "The John/john total of number are:" $John
echo "The Mary/mary total of number are:" $Mary
if [ "$John" -eq "$Mary" ]
then
	echo "Is true. Your input John/john number of times are same the Mary/mary."
else
	echo "False. John/john number of times are difference to Mary/mary."

fi
rm -f tmp 1
