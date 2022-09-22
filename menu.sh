#!/bin/bash

clear
RED="\e[031;1m"
GREEN="\e[032;1m"
YELLOW="\e[033;1m"
BLUE="\e[034;1m"
PURPLE="\e[035;1m"
CYAN="\e[036;1m"
LIGHT="\e[037;1m"
NC="\e[0m"

echo -e ""
echo -e ""
echo -e "  ${YELLOW}------=[${NC} ${RED}AUTO SCRIPT PREMIUM BY SSHINJECTOR.NET${NC} ${YELLOW}]=------ ${NC}"
DOMAIN=$(cat /etc/xray/domain.conf)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IP=$(curl -s ipinfo.io/ip )
JAM=$(date +"%T")
HARI=$(date +"%A")
TGL=$(date +"%d-%B-%Y")
echo -e ""
echo -e "          ${GREEN} ISP NAME :${NC}${LIGHT} ${ISP} ${NC}"
echo -e "          ${GREEN} DOMAIN   :${NC}${LIGHT} ${DOMAIN} ${NC}"
echo -e "          ${GREEN} IP VPS   :${NC}${LIGHT} ${IP} ${NC}"
echo -e "          ${GREEN} DAY      :${NC}${LIGHT} ${HARI} ${NC}"
echo -e "          ${GREEN} DATE     :${NC}${LIGHT} ${TGL} ${NC}"
echo -e "          ${GREEN} TIME     :${NC}${LIGHT} ${JAM} ${NC}"
echo -e "          ${GREEN} CITY     :${NC}${LIGHT} ${CITY} ${NC}"
echo -e "          ${GREEN} TIMEZONE :${NC}${LIGHT} ${WKT} ${NC}"
echo -e ""
echo -e " ${YELLOW} -------------------=[${NC} ${RED}XRAY SERVICE${NC} ${YELLOW}]=------------------- ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT})${NC} ${LIGHT}PANEL SHADOWSOCKS${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT})${NC} ${LIGHT}PANEL TROJAN${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT})${NC} ${LIGHT}PANEL VLESS${NC}"
echo -e "    ${GREEN} 4${NC}${LIGHT})${NC} ${LIGHT}PANEL VMESS${NC}"
echo -e ""
echo -e " ${YELLOW} -------------------=[${NC} ${RED}OPTIONS MENU${NC} ${YELLOW}]=------------------- ${NC}"
echo -e "    ${GREEN} 5${NC}${LIGHT})${NC} ${LIGHT}ADD SUBDOMAIN HOST FOR VPS${NC}"
echo -e "    ${GREEN} 6${NC}${LIGHT})${NC} ${LIGHT}RENEW CERTIFICATE XRAY${NC}"
echo -e "    ${GREEN} 7${NC}${LIGHT})${NC} ${LIGHT}AUTOBACKUP DATA VPS${NC}"
echo -e "    ${GREEN} 8${NC}${LIGHT})${NC} ${LIGHT}BACKUP DATA VPS${NC}"
echo -e "    ${GREEN} 9${NC}${LIGHT})${NC} ${LIGHT}RESTORE DATA VPS${NC}"
echo -e "   ${GREEN} 10${NC}${LIGHT})${NC} ${LIGHT}LIMIT BANDWITH SPEED SERVER${NC}"
echo -e "   ${GREEN} 11${NC}${LIGHT})${NC} ${LIGHT}CHECK USAGE OF VPS RAM${NC}"
echo -e "   ${GREEN} 12${NC}${LIGHT})${NC} ${LIGHT}REBOOT VPS${NC}"
echo -e "   ${GREEN} 13${NC}${LIGHT})${NC} ${LIGHT}SPEEDTEST VPS${NC}"
echo -e "   ${GREEN} 14${NC}${LIGHT})${NC} ${LIGHT}INFORMATION DISPLAY SYSTEM${NC}" 
echo -e "   ${GREEN} 15${NC}${LIGHT})${NC} ${LIGHT}INFORMATION SCRIPT${NC}"
echo -e "   ${GREEN} 16${NC}${LIGHT})${NC} ${LIGHT}CLEAR LOG VPS${NC}"
echo -e "   ${GREEN} 17${NC}${LIGHT})${NC} ${LIGHT}CEK BANDWIDTH VPS${NC}"
echo -e "   ${GREEN} 18${NC}${LIGHT})${NC} ${LIGHT}CEK RUNNING SERVICE${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e "       ${GREEN} x${NC}${LIGHT})${NC} ${LIGHT}EXIT${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-18 or type x to exit the menu] : " menuu
echo -e ""
case $menuu in
1)
clear
menu-ss
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
2)
clear
menu-tr
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
3)
clear
menu-vl
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
4)
clear
menu-vm
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
5)
clear
addhost
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
6)
clear
xray-cert
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
7)
clear
autobackup
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
8)
clear
backup
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
9)
clear
restore
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
10)
clear
limit
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
11)
clear
vmstat -s
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
12)
clear
reboot
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
13)
clear
speedtest
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
14)
clear
run
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
15)
clear
info
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
16)
clear
c-log
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
17)
clear
vnstat -h
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
18)
clear
run
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
x)
exit
bash
;;
*)
echo " Please enter the correct number!!!"
;;
esac
