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
echo -e " ${YELLOW} -----------------=[${NC} ${RED}PANEL XRAY VMESS${NC} ${YELLOW}]=----------------- ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT})${NC} ${LIGHT}CREATE USER VMESS${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT})${NC} ${LIGHT}DELETE USER VMESS${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT})${NC} ${LIGHT}RENEW USER VMESS${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e "       ${GREEN} x${NC}${LIGHT})${NC} ${LIGHT}EXIT${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-3 or type x to return to main menu] : " menuvm
echo -e ""
case $menuvm in
1)
clear
addvmess
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-vm
;;
2)
clear
delvmess
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-vm
;;
3)
clear
renewvmess
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-vm
;;
x)
menu
;;
*)
menu-vm
;;
esac
