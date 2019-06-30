#!/usr/bin/env bash

### ***************************************************************************
#
# 1. Showing your outgoing IP.
# 2. Test the speed of your outgoing network.
#
# Dependencies:
# - curl. dns
#
# Made(Creator)  Unknown
# Contact:       Unknown
# Created:       Unknown
# Last modified: August 9, 2018
# Passed(tested) for:
#   - macOS 10 to 10.13.5
#   - Ubuntu 14 to 17
#
### **************************************************************************

clear
printf "Showing your outgoing IP in below."
printf "\nGetting response from the \033[40;36mipinfo.io\033[0m..\n."
curl ipinfo.io
printf "\n"
read -p  "Input a site URL address for you want to testing: " site
curl -o /dev/null -s -w \
"DNS Resolve(Sec.): %{time_namelookup}\n\
Client -> Server(Sec.): %{time_connect}\n\
Server Respon(Sec.): %{time_starttransfer}\n\
Total cost time(Sec.): %{time_total}\n" \
$site
