#!/usr/bin/bash
# Ask for the vpn type

echo Enter the VPN name: htb, vhl, thm

read vpn

if [[ ${vpn} == "htb" ]]
then 
	echo ${vpn}
fi
