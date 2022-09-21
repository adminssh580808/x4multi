#!/bin/bash

red="\033[0;32m"
green="\033[0;32m"
NC="\e[0m"
clear
echo ""
echo -e "\e[94m    .----------------------------------------------------.    "
echo -e "\e[94m    |              DISPLAYING RUNNING SYSTEM             |    "
echo -e "\e[94m    '----------------------------------------------------'    "
echo -e "\e[0m"
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       Xray Shadowsocks : Xray Shadowsocks Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       Xray Shadowsocks : Xray Shadowsocks Service is "$red"not running (Error)"$NC""        
fi
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       Xray Trojan      : Xray Trojan Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       Xray Trojan      : Xray Trojan Service is "$red"not running (Error)"$NC""        
fi
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       Xray Vless       : Xray Vless Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       Xray Vless       : Xray Vless Service is "$red"not running (Error)"$NC""    
fi
status="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       Xray Vmess       : Xray Vmess Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       Xray Vmess       : Xray Vmess Service is "$red"not running (Error)"$NC""        
fi
tatus="$(systemctl show xray@tls.service --no-page)"                                   
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       Xray Multi       : Xray Multi Service is "$green"running"$NC""                  
else                                                                                    
echo -e "       Xray Multi       : Xray Multi Service is "$red"not running (Error)"$NC""        
fi
status="$(systemctl show nginx.service --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e "       Nginx            : Nginx Service is "$green"running"$NC""                
else                                                                                    
echo -e "       Nginx            : Nginx Service is "$red"not running (Error)"$NC""      
fi
echo ""
echo -e "\e[94m==============================================================$NC"
echo -e "\e[94m ------------------------------------------------------------$NC" 
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
echo "   - Shadowsocks WS/GRPC     : 443"
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"
echo "   - Timezone                : Asia/Jakarta (GMT +7)"
echo "   - Fail2Ban                : [ON]"
echo "   - Dflate                  : [ON]"
echo "   - IPtables                : [ON]"
echo "   - Auto-Reboot             : [ON]"
echo "   - IPv6                    : [OFF]"
echo "   - Autoreboot On           : 05:00 WIB GMT +7"
echo "   - Autobackup Data"
echo "   - Auto Delete Expired Account"
echo "   - Fully automatic script"
echo "   - VPS settings"
echo "   - Admin Control"
echo "   - Restore Data"
echo "   - Full Orders For Various Services"
echo -e "\e[94m ------------------------------------------------------------$NC"
echo -e "\e[94m==============================================================$NC"
