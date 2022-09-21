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
echo -e " ${YELLOW} ----------------=[${NC} ${RED}PANEL XRAY TROJAN${NC} ${YELLOW}]=---------------- ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT})${NC} ${LIGHT}CREATE USER TROJAN${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT})${NC} ${LIGHT}DELETE USER TROJAN${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT})${NC} ${LIGHT}RENEW USER TROJAN${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e "       ${GREEN} x${NC}${LIGHT})${NC} ${LIGHT}EXIT${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-3 or type x to return to main menu] : " menutr
echo -e ""
case $menutr in
1)
clear
addtrojan
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-tr
;;
2)
clear
deltrojan
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-tr
;;
3)
clear
renewtrojan
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-tr
;;
x)
menu
;;
*)
menu-tr
;;
esac
