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

# CRON
cron=$( systemctl status cron | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $cron == "running" ]]; then
    BCD1="${GREEN}ON${NC}"
else
    BCD1="${RED}OFF${NC}"
fi

# NGINX
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    BCD2="${GREEN}ON${NC}"
else
    BCD2="${RED}OFF${NC}"
fi

# XRAY
xray=$( systemctl status xray@tls | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    BCD3="${GREEN}ON${NC}"
else
    BCD3="${RED}OFF${NC}"
fi

echo -e " ${YELLOW} ---------=[${NC} ${RED}PREMIUM PANEL MENU${NC} ${YELLOW}]=--------- ${NC}"
DM=$(cat /etc/xray/domain.conf)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IP=$(curl -s ipinfo.io/ip )
JAM=$(date +"%T")
HARI=$(date +"%A")
TGL=$(date +"%d-%B-%Y")
echo -e " ${YELLOW} ------------------------------------------ ${NC}" 
echo -e "    ${GREEN} ISP NAME  ${NC}${LIGHT}: ${ISP} ${NC}"
echo -e "    ${GREEN} DOMAIN    ${NC}${LIGHT}: ${DM} ${NC}"
echo -e "    ${GREEN} IP SERVER ${NC}${LIGHT}: ${IP} ${NC}"
echo -e "    ${GREEN} TIME ZONE ${NC}${LIGHT}: ${WKT} ${NC}"
echo -e "    ${GREEN} CITY      ${NC}${LIGHT}: ${CITY} ${NC}"
echo -e "    ${GREEN} DAY       ${NC}${LIGHT}: ${HARI} ${NC}"
echo -e "    ${GREEN} DATE      ${NC}${LIGHT}: ${TGL} ${NC}"
echo -e "    ${GREEN} TIME      ${NC}${LIGHT}: ${JAM} WIB${NC}"
echo -e " ${YELLOW} ------------------------------------------ ${NC}"
echo -e "  ${LIGHT}  CRON =${NC} $BCD1    ${LIGHT} NGINX =${NC} $BCD2    ${LIGHT} XRAY =${NC} $BCD3  "
echo -e " ${YELLOW} ------------------------------------------ ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT}). PANEL SHADOWSOCKS${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT}). PANEL TROJAN${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT}). PANEL VLESS${NC}"
echo -e "    ${GREEN} 4${NC}${LIGHT}). PANEL VMESS${NC}"
echo -e "    ${GREEN} 5${NC}${LIGHT}). RENEW SUBDOMAIN${NC}"
echo -e "    ${GREEN} 6${NC}${LIGHT}). RENEW CERT XRAY${NC}"
echo -e "    ${GREEN} 7${NC}${LIGHT}). CHECK USAGE RAM${NC}"
echo -e "    ${GREEN} 8${NC}${LIGHT}). CHECK BANDWIDTH SYSTEM${NC}"
echo -e "    ${GREEN} 9${NC}${LIGHT}). SPEEDTEST VPS${NC}"
echo -e "   ${GREEN} 10${NC}${LIGHT}). INFO RUNNING SYSTEM${NC}" 
echo -e "   ${GREEN} 11${NC}${LIGHT}). INFO SCRIPT${NC}"
echo -e "   ${GREEN} 12${NC}${LIGHT}). REBOOT VPS${NC}"
echo -e " ${YELLOW} ------------------------------------------ ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-12 or type x to exit the menu] : " menuu
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
#!/bin/bash
clear

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
#!/bin/bash

red="\033[0;32m"
green="\033[0;32m"
NC="\e[0m"
clear
echo ""
echo -e "\e[94m    .----------------------------------------------------.    "
echo -e "\e[94m    |              DISPLAYING RUNNING SYSTEM             |    "
echo -e "\e[94m    '----------------------------------------------------'    $NC"
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       XRAY SHADOWSOCKS : Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       XRAY SHADOWSOCKS : Service is "$red"not running (Error)"$NC""        
fi
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       XRAY TROJAN      : Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       XRAY TROJAN      : Service is "$red"not running (Error)"$NC""        
fi
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       XRAY VLESS       : Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       XRAY VLESS       : Service is "$red"not running (Error)"$NC""    
fi
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       XRAY VMESS       : Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       XRAY VMESS       : Service is "$red"not running (Error)"$NC""        
fi
tatus="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       XRAY MULTI       : Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       XRAY MULTI       : Service is "$red"not running (Error)"$NC""        
fi
status="$(systemctl show nginx.service --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       NGINX            : Service is "$green"running"$NC""                
else                                                                                    
echo -e "       NGINX            : Service is "$red"not running (Error)"$NC""      
fi
status="$(systemctl show cron.service --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       CRON             : Service is "$green"running"$NC""                
else                                                                                    
echo -e "       CRON             : Service is "$red"not running (Error)"$NC""      
fi
echo -e "\e[94m    ------------------------------------------------------"
echo ""
read -p "Click enter to return to the main menu..."
clear
menu
;;
10)
#!/bin/bash

RED="\033[0;32m"
GREEN="\033[0;32m"
NC="\e[0m"
clear

echo ""
echo -e "${RED}==============================================================$NC"
echo -e "${RED} ------------------------------------------------------------$NC" 
echo "   >>> Service & Port"
echo "   - Nginx                   : 81"
echo "   - XRAY Vmess TLS          : 443"
echo "   - XRAY Vmess Non TLS      : 80"
echo "   - XRAY Vmess GRPC         : 443"
echo "   - XRAY Vless TLS          : 443"
echo "   - XRAY Vless Non TLS      : 80"
echo "   - XRAY Vless GRPC         : 443"
echo "   - Trojan TCP TLS          : 443"
echo "   - Trojan GRPC             : 443"
echo "   - Trojan WS               : 443"
echo "   - Shadowsocks WS TLS      : 443"
echo "   - Shadowsocks GRPC        : 443"
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"
echo "   - Timezone                : Asia/Jakarta (GMT +7)"
echo "   - Fail2Ban                : [ON]"
echo "   - Dflate                  : [ON]"
echo "   - IPtables                : [ON]"
echo "   - Auto-Reboot             : [ON]"
echo "   - IPv6                    : [OFF]"
echo "   - Autoreboot On           : 05:00 WIB GMT +7"
echo "   - Auto Delete Expired Account"
echo "   - Fully automatic script"
echo "   - VPS settings"
echo "   - Admin Control"
echo "   - Full Orders For Various Services"
echo -e "${RED} ------------------------------------------------------------$NC"
echo -e "${RED}==============================================================$NC"
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
menu
;;
esac
