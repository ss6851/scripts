##!/usr/bin/bash

Y='\033[1;33m'
R='\033[0;31m'
NC='\033[0m' #No color

if [ "$#" == "2" ]; then

	mkdir www-enum; clear

	printf "${Y}[+] Performing Nikto scan on port $2 ${NC}\n\n"
	nikto -host $1:$2 | tee www-enum/nikto$2.txt

	printf "\n\n${Y}[+] Performing dir scan w/ extensions on port $2 ${NC}\n\n"
	gobuster -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt dir -f -x php,sh,aspx,asp,config,txt,cgi -u http://$1:$2 -o www-enum/gobuster$2.ext.out

	printf "\n\n${Y}[+] Performing normal dir scan on port $2 ${NC}\n\n"
	gobuster -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt dir -u http://$1:$2 -o www-enum/gobuster$2.dir.out
else
	printf "[${R}[+] Usage: /opt/script/./web-enum.sh <IP-Address> <Port Number>${NC}\n"
fi
