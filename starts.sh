#!/bin/bash
clear
magenta='\033[0;35m'
r='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
caracteres="-\|/"

ip_priv=$(ifconfig | grep 192)
ip_priv1=$(echo "$ip_priv" | awk '{$1=$1};1' | cut -d' ' -f1-2)
ip=$(echo "$ip_priv1" | awk '{print $2}')
ip1=$(echo "$ip" | cut -d'.' -f1-3).0
mac=$(ip a | grep -A 1 "eth0" | awk '/link\/ether/ {print $2}')

hostname=$(hostname)
actual_user=$(whoami)

ip_pub=$(wget -qO- https://api.ipify.org)

disk_space=$(df -h | grep /dev/sd | awk '{print $1 " | Size: " $2 " Use: " $5}')

echo -e "$green[+]$r IP private: $magenta$ip_priv1$r"
echo -e "$green[+]$r Mac Address: $magenta$mac$r"
echo -e "$green[+]$r Hostname-ActualUser: $hostname:$magenta$actual_user$r"
echo -e "$green[+]$r Disk space: $disk_space"
echo -e "$red[!]$r Ip public: $red$ip_pub$r"
echo -e "$green[+]$r Users in your network and their open ports:"

scan=$(nmap -min-rate 5000 -T5 $ip1-255 | awk '/Nmap scan report for/{ip=$NF} /open/{gsub("/tcp", ""); ports[ip] = ports[ip] "," $1} END{for (ip in ports){gsub("^,","",ports[ip]); print "ip:" ip " ports:" ports[ip]}}')

for i in {1..25}; do
	indice=$(( (i - 1) % 4 + 1 ))
	caracter="${caracteres:indice-1:1}"
	printf "\r %s" "$caracter"
	sleep 0.25
done
echo " "
echo -e "$scan"
echo " "
echo -e "$green[?]$r ¿Connect to red tor and hide your public IP? (y, n)"
read confirmation

if [ "$confirmation" = "y" ]; then
	if [ ! -d "torghost" ];then
		inst1=$(sudo git clone https://github.com/SusmithKrishnan/torghost.git)
		inst2=$(cd torghost/)
		inst3=$(sudo chmod +x torghost/build.sh)
		inst4=$(bash torghost/build.sh)
		conection=$(sudo python3 torghost/torghost.py --start Torghost)
		ip_tor=$(wget -qO- https://api.ipify.org)
		echo -e "$red[!]$r New Ip public: $red$ip_tor$r"
	else
		conection=$(sudo python3 torghost/torghost.py --start Torghost)		
		ip_tor=$(wget -qO- https://api.ipify.org)
		echo -e "$red[!]$r New Ip public: $red$ip_tor$r"
	fi
else
	echo -e "$red[!]$rYour Ip and location are visible to others: $ip_pub"
fi









