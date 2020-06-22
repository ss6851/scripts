#!/usr/bin/bash
Y='\033[1;33m'
R='\033[0;31m'
NC='\033[0m' #No color

pkill -9 python3 && cd /opt && python3 -m http.server 9316 &

pkill -9 openvpn
pid=$(ps aux | grep http.server | awk '{print $2}' | head -n 1) && kill -9 ${pid}
clear

echo Enter the VPN name: htb, vhl, thm
read vpn

echo Enter the directory name
read dir

if [[ ${vpn} == "htb" ]]
then
	thmvpn_pid=$(ps aux | grep ss6851.ovpn | awk '{print $2}' | head -n 1) && kill -9 ${thmvpn_pid}
	openvpn /opt/vpn/ss2016.ovpn &
	mkdir -p /root/htb/${dir}/exploits
	cd /root/htb/${dir}/exploits && python3 -m http.server 80 &

elif [[ ${vpn} == "thm"  ]]
then 
	htbvpn_pid=$(ps aux | grep ss2016.ovpn | awk '{print $2}' | head -n 1) && kill -9 ${htbvpn_pid}
	openvpn /opt/vpn/ss6851.ovpn &
	mkdir -p /root/thm/${dir}/exploits
	cd /root/thm/${dir}/exploits && python3 -m http.server 80 &

else
	echo "${R}Wrong input detected. Please try again ${NC}\n"
fi

