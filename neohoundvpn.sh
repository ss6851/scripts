#!/usr/bin/bash
openvpn /opt/academy.ovpn &
neo4j console &
sleep 5s 
/opt/BloodHound-linux-x64/./BloodHound &
