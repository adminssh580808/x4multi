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
echo -e "  ${YELLOW}----------=[${NC} ${RED}PREMIUM PANEL MENU${NC} ${YELLOW}]=---------- ${NC}"
DOMAIN=$(cat /etc/xray/domain.conf)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IP=$(curl -s ipinfo.io/ip )
JAM=$(date +"%T")
HARI=$(date +"%A")
TGL=$(date +"%d-%B-%Y")
echo -e "      ${GREEN} ISP NAME${NC}${LIGHT} : ${ISP} ${NC}"
echo -e "      ${GREEN} DOMAIN${NC}${LIGHT}   : ${DOMAIN} ${NC}"
echo -e "      ${GREEN} IP VPS${NC}${LIGHT}   : ${IP} ${NC}"
echo -e "      ${GREEN} DAY${NC}${LIGHT}      : ${HARI} ${NC}"
echo -e "      ${GREEN} DATE${NC}${LIGHT}     : ${TGL} ${NC}"
echo -e "      ${GREEN} TIME${NC}${LIGHT}     : ${JAM} ${NC}"
echo -e "      ${GREEN} CITY${NC}${LIGHT}     : ${CITY} ${NC}"
echo -e "      ${GREEN} TIMEZONE${NC}${LIGHT} : ${WKT} ${NC}"
echo -e "  ${YELLOW}-------------------------------------------- ${NC}"
echo -e "  ${LIGHT}  CRON =${NC} BCD1      ${LIGHT}NGINX =${NC} $BCD2      ${LIGHT}XRAY =${NC} $BCD3"
echo -e "  ${YELLOW}-------------------------------------------- ${NC}"
echo -e "  ${YELLOW}-------------=[${NC} ${RED}XRAY SERVICE${NC} ${YELLOW}]=------------- ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT}). PANEL SHADOWSOCKS${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT}). PANEL TROJAN${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT}). PANEL VLESS${NC}"
echo -e "    ${GREEN} 4${NC}${LIGHT}). PANEL VMESS${NC}"
echo -e ""
echo -e "  ${YELLOW}-------------=[${NC} ${RED}OPTIONS MENU${NC} ${YELLOW}]=------------- ${NC}"
echo -e "    ${GREEN} 5${NC}${LIGHT}). ADD NEW SUBDOMAIN${NC}"
echo -e "    ${GREEN} 6${NC}${LIGHT}). RENEW CERT XRAY${NC}"
echo -e "    ${GREEN} 7${NC}${LIGHT}). SPEEDTEST SERVER${NC}"
echo -e "    ${GREEN} 8${NC}${LIGHT}). CHECK BANDWIDTH VPS${NC}"
echo -e "    ${GREEN} 9${NC}${LIGHT}). CHECK RUNNING SERVICE${NC}"
echo -e "   ${GREEN} 10${NC}${LIGHT}). INFORMATION SCRIPT${NC}"
echo -e "   ${GREEN} 11${NC}${LIGHT}). REBOOT VPS${NC}"
echo -e "  ${YELLOW}-------------------------------------------- ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-11 or type x to exit the menu] : " menuu
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
#!/bin/bash
clear

read -rp "Input ur domain : " -e domain

echo "$domain" >/etc/xray/domain.conf
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
#!/bin/bash

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
