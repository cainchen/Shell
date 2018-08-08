#!bin/bash

### ***************************************************************************
#
# Move all folders/files to a specified folder and you also can excluded the
# specifying file/folder.
#
# Dependencies:
# - No specified
#
# Made(Creator)  Cain Chen/CHEN YI CHI
# Contact:       shu90129@gmail.com
# Created:       June 2018
# Last modified: August 9, 2018
# Passed(tested) for:
#   - macOS 10 to 10.13.5
#   - Ubuntu 14 to 17
#
### **************************************************************************

clear
printf "Showing itmes in this path:\n----------[$PWD]----------\n" && ls .
printf "\nInput the file or folder you want to exclude: " && read sour
printf "\nInput a target folder for placing those files/folders: " && read dest
printf "\nMoving down !"
shopt -s extglob
mv !($sour) $dest
printf "\n"
printf "\nShowing existing in below:\n ----------[$PWD]----------\n"
ls .
printf "\nShowing destination in below:\n ----------[$dest]------------\n"
tree -CD -L 2 $dest
