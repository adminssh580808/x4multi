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
echo -e " ${YELLOW} -------=[${NC} ${RED}PANEL MENU BY SSHINJECTOR.NET${NC} ${YELLOW}]=------- ${NC}"
DM=$(cat /etc/xray/domain.conf)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IP=$(curl -s ipinfo.io/ip )
JAM=$(date +"%T")
HARI=$(date +"%A")
TGL=$(date +"%d-%B-%Y")
echo -e ""
echo -e "          ${GREEN} ISP NAME :${NC}${LIGHT} ${ISP} ${NC}"
echo -e "          ${GREEN} DOMAIN   :${NC}${LIGHT} ${DM} ${NC}"
echo -e "          ${GREEN} IP VPS   :${NC}${LIGHT} ${IP} ${NC}"
echo -e "          ${GREEN} CITY     :${NC}${LIGHT} ${CITY} ${NC}"
echo -e "          ${GREEN} TIMEZONE :${NC}${LIGHT} ${WKT} ${NC}"
echo -e "          ${GREEN} DAY      :${NC}${LIGHT} ${HARI} ${NC}"
echo -e "          ${GREEN} DATE     :${NC}${LIGHT} ${TGL} ${NC}"
echo -e "          ${GREEN} TIME     :${NC}${LIGHT} ${JAM} ${NC}"
echo -e ""
echo -e " ${YELLOW} ------------------------------------------------- ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT})${NC} ${LIGHT}PANEL SHADOWSOCKS${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT})${NC} ${LIGHT}PANEL TROJAN${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT})${NC} ${LIGHT}PANEL VLESS${NC}"
echo -e "    ${GREEN} 4${NC}${LIGHT})${NC} ${LIGHT}PANEL VMESS${NC}"
echo -e "    ${GREEN} 5${NC}${LIGHT})${NC} ${LIGHT}ADD NEW HOST${NC}"
echo -e "    ${GREEN} 6${NC}${LIGHT})${NC} ${LIGHT}RENEW CERT XRAY${NC}"
echo -e "   ${GREEN}  7${NC}${LIGHT})${NC} ${LIGHT}CHECK USAGE RAM${NC}"
echo -e "   ${GREEN}  8${NC}${LIGHT})${NC} ${LIGHT}CHECK BANDWIDTH VPS${NC}"
echo -e "   ${GREEN}  9${NC}${LIGHT})${NC} ${LIGHT}SPEEDTEST VPS${NC}"
echo -e "   ${GREEN} 10${NC}${LIGHT})${NC} ${LIGHT}INFO RUNNING SYSTEM${NC}" 
echo -e "   ${GREEN} 11${NC}${LIGHT})${NC} ${LIGHT}INFO SCRIPT${NC}"
echo -e "   ${GREEN} 12${NC}${LIGHT})${NC} ${LIGHT}REBOOT VPS${NC}"
echo -e " ${YELLOW} ------------------------------------------------- ${NC}"
echo -e "       ${GREEN} x${NC}${LIGHT})${NC} ${LIGHT}EXIT${NC}"
echo -e " ${YELLOW} ------------------------------------------------- ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-18 or type x to exit the menu] : " menuu
echo -e ""
case $menuu in
1)
menu-ss
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
2)
menu-tr
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
3)
menu-vl
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
4)
menu-vm
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
5)
clear
#!/bin/bash
clear

read -rp "Input ur domain : " -e domain

echo "$domain" >/etc/xray/domain.conf
sleep 1
domain=$(cat /etc/xray/domain.conf)

# Menghentikan Port 443 & 80 jika berjalan
lsof -t -i tcp:80 -s tcp:listen | xargs kill >/dev/null 2>&1
lsof -t -i tcp:443 -s tcp:listen | xargs kill >/dev/null 2>&1
sleep 0.5
systemctl stop nginx
cd
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    
systemctl daemon-reload
systemctl restart nginx
systemctl restart xray@tls
systemctl restart xray@nontls
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
6)
xray-cert
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
7)
clear
vmstat -s
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
8)
clear
speedtest
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
9)
clear
run
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
10)
clear
info
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
11)
clear
vnstat -h
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
12)
echo "Reboot System..."
sleep 1
reboot
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
