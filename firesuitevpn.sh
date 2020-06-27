#!/usr/bin/bash
Y='\033[1;33m'
R='\033[0;31m'
NC='\033[0m' #No color

#Kill previous python3 web servers and start a new process
clear
pkill -9 python3
sleep 2s && clear
#smb_pid=$(ps aux | grep smbserver.py | awk '{print $2}' | head -n 1) && kill -9 ${smb_pid}
cd /opt && python3 -m http.server 9316 &
sleep 2s && clear && impacket-smbserver tools /opt/priv-esc/Windows &
sleep 2s && clear

echo Enter the VPN name: htb, vhl, thm
read vpn

echo Enter the directory name
read dir

if [[ ${vpn} == "htb" ]]
then
	#Checks if there's a previous vpn process. If yes, then kills it.
	thmvpn_pid=$(ps aux | grep ss6851.ovpn | awk '{print $2}' | head -n 1) && kill -9 ${thmvpn_pid}
	openvpn /opt/vpn/ss2016.ovpn &
	mkdir -p /root/htb/${dir}/exploits
	cd /root/htb/${dir}/exploits && python3 -m http.server 80 &

elif [[ ${vpn} == "thm"  ]]
then 
	#Checks if there's a previous vpn process. If yes, then kills it.
	htbvpn_pid=$(ps aux | grep ss2016.ovpn | awk '{print $2}' | head -n 1) && kill -9 ${htbvpn_pid}
	openvpn /opt/vpn/ss6851.ovpn &
	mkdir -p /root/thm/${dir}/exploits
	cd /root/thm/${dir}/exploits && python3 -m http.server 80 &

else
	printf "${R}[+] Wrong input detected. Please try again.${NC}\n"
fi

sleep 3s
clear
