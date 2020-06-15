#!/usr/bin/bash
# Ask for the vpn type

echo Enter the VPN name: htb, vhl, thm

read vpn

if [[ ${vpn} == "htb" ]]
then
	openvpn /opt/vpn/ss2016.ovpn &
elif [[ ${vpn} == "thm"  ]]
then 
	openvpn /opt/vpn/ss6851.ovpn &
else
	echo "Wrong input detected. Please try again"
fi

