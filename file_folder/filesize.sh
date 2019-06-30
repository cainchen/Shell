#!/usr/bin/env bash
clear
if [ $1 == "f" ];
then
find $2 -type f -printf '%s %p\n' | sort -nr | awk '
     BEGIN {
        split("KB,MB,GB,TB", Units, ",");
     }
     {
        u = 1;
        while ($1 >= (1024*1024)) {
           $1 = $1 / (1024*1024);
           u += 1
        }
        $1 = sprintf("%.1f %s", $1, Units[u]);
        print $0;
     }
'
elif [ $1 == "d" ];
then
du -k $2 | sort -nr | awk '
     BEGIN {
        split("KB,MB,GB,TB", Units, ",");
     }
     {
        u = 1;
        while ($1 >= 1024) {
           $1 = $1 / 1024;
           u += 1
        }
        $1 = sprintf("%.1f %s", $1, Units[u]);
        print $0;
     }
'
else
printf "\033[36;31mInput error!!\033[0m Command is 'filesize (\033[36;40mf\033[0m or \033[36md\033[0m) (\033[36;40mpath\033[0m)' \n"
fi
