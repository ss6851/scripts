#!/usr/bin/bash
# Ask for the vpn type
pkill -9 openvpn
pkill -9 python3
clear

echo Enter the VPN name: htb, vhl, thm

read vpn

echo Enter the directory name

read dir

if [[ ${vpn} == "htb" ]]
then
	openvpn /opt/vpn/ss2016.ovpn &
	mkdir -p /root/htb/${dir}/exploits
	cd /root/htb/${dir}/exploits && python3 -m http.server 80 &

elif [[ ${vpn} == "thm"  ]]
then 
	openvpn /opt/vpn/ss6851.ovpn &
	mkdir -p /root/thm/${dir}/exploits
	cd /root/thm/${dir}/exploits && python3 -m http.server 80 &

else
	echo "Wrong input detected. Please try again"
fi

