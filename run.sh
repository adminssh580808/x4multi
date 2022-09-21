#!/bin/bash

red="\033[0;32m"
green="\033[0;32m"
NC="\e[0m"
clear
echo ""
echo -e "\e[94m    .----------------------------------------------------.    "
echo -e "\e[94m    |              DISPLAYING RUNNING SYSTEM             |    "
echo -e "\e[94m    '----------------------------------------------------'    "
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
