#!/bin/bash

### ***************************************************************************
#
# No description yet.
#
# Dependencies:
# - No specified
#
# Made(Creator)  Cain Chen/CHEN YI CHI
# Contact:       shu90129@gmail.com
# Created:       2017
# Last modified: August 9, 2018
# Passed(tested) for:
#   - macOS 10 to 10.13.5
#   - Ubuntu 14 to 17                                                                                                                                                                                                               
#
### **************************************************************************

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
