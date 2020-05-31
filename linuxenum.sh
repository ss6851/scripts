#!/bin/bash

clear;

Y='\033[1;33m'
NC='\033[0m' #No color

printf "${Y}[+] Checking permissions on passwd and sudoers ${NC}\n\n"
ls -l /etc/passwd
ls -l /etc/sudoers

printf "\n${Y}[+]Currently, $USER belongs to the following groups${NC}\n"
groups

printf "\n\n${Y}[+] Determining the running processes ${NC}\n\n"
ps aux 2>/dev/null | grep -v -e '\['

printf "\n\n${Y}[+] Determing cron jobs ${NC}\n\n"
cat /etc/crontab

printf "\n\n${Y}[+] Determining systemd timers ${NC}\n\n"
systemctl list-timers --all 2>/dev/null

find / -type d -maxdepth 1 2>/dev/null > /dev/shm/dir; for i in $(cat /dev/shm/dir);do printf "\n\n${Y}[+] Contents of $i ${NC}\n\n";ls -l $i; done

printf "\n\n${Y}[+] Files owned by $USER ${NC}\n\n"
if [[ $USER != "root" ]] 
then 
	find / -user $USER -exec ls -l {} \; 2>/dev/null | grep -v sys 
fi

printf "\n\n${Y}[+] Determining SUID files ${NC}\n\n"
find / -perm -4000 2>/dev/null

printf "\n\n${Y}[+] Determining the listening ports ${NC}\n\n"
netstat -alnp | grep LIST

printf "\n\n${Y}[+] Checking sudo permissions on $USER ${NC}\n\n"
sudo -l
