#!/usr/bin/bash

if [ "$#" = "1" ]; then
	mkdir nmap;clear
	printf "[+] Performing the default scan\n\n"
	nmap -Pn -sC -sV -oN nmap/initial.nmap $1

	printf "\n[+] Performing an all port scan\n\n"
	nmap -Pn -p1-65535 -oG nmap/allports.gnmap $1

	ports=$(grep -oP ' [\d]{1,6}/' nmap/allports.gnmap | sed 's/\///g' | tr '\n' ',')

	printf "\n[+] Performing a targetted port scan\n\n"

	nmap -Pn -p"${ports}" -sC -sV -oN nmap/targetted.nmap $1

	printf "\n\n [+] Performing an all ports vuln detection scan\n\n"
	nmap -Pn -p"${ports}" --script vuln -oN nmap/vuln.nmap $1

	printf "\n\n[+] Performing a UDP vuln scan\n\n"
	nmap -Pn -vvv -sU -oN nmap/udp.nmap $1
else
	printf "[+] Usage: ./initial.sh <IP-Address>\n"
fi
