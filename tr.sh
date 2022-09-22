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

function addtr(){
clear

IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)

read -p "Username : " username
username="$(echo ${username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n')"

# // Validate Input
if [[ $username == "" ]]; then
    clear
    echo -e "${FAIL} Silakan Masukan Username terlebih dahulu !"
    exit 1
fi

# // Checking User already on vps or no
if [[ "$(cat /etc/xray/trojan-client.conf | grep -w ${username})" != "" ]]; then
    clear
    echo -e "${FAIL} User [ ${Username} ] sudah ada !"
    exit 1
fi

# // Expired Date
read -p "Expired  : " Jumlah_Hari
exp=$(date -d "$Jumlah_Hari days" +"%Y-%m-%d")
hariini=$(date -d "0 days" +"%Y-%m-%d")

# // Get UUID
uuid=$(uuidgen)

# // Generate New UUID & Domain
domain=$(cat /etc/xray/domain.conf)


# // Getting Vmess port using grep from config
tls_port=$(cat /etc/xray/config/xray/tls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g')

# // Input Your Data to server
cat /etc/xray/config/xray/tls.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","flow": "xtls-rprx-direct","email":"'${username}'","level": 0 }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq '.inbounds[1].settings.clients += [{"password": "'${uuid}'","email":"'${username}'" }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq '.inbounds[4].settings.clients += [{"password": "'${uuid}'","email":"'${username}'" }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
echo -e "Trojan $username $exp $uuid" >>/etc/xray/trojan-client.conf

# // Make Configruation Link
grpc_link="trojan://${uuid}@${domain}:${tls_port}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc#${username}"
tcp_tls_link="trojan://${uuid}@${domain}:${tls_port}?security=tls&headerType=none&type=tcp#${username}"
ws_tls_link="trojan://${uuid}@${domain}:${tls_port}?path=%2Ftrojan&security=tls&type=ws#${username}"

# // Restarting XRay Service
systemctl restart xray@tls

# // Success
clear
echo -e "==============================="
echo -e "    TROJAN ACCOUNT DETAILS"
echo -e "==============================="
echo -e " ISP         : ${ISPNYA}"
echo -e " Remarks     : ${username}"
echo -e " IP          : ${IPNYA}"
echo -e " Address     : ${domain}"
echo -e " Port        : ${tls_port}"
echo -e " Password    : ${uuid}"
echo -e " Path WS     : /trojan"
echo -e " ServiceName : trojan-grpc"
echo -e " Expired On  : ${exp}"
echo -e "==============================="
echo -e " TROJAN TCP TLS LINK :"
echo -e " ${tcp_tls_link}"
echo -e "-------------------------------"
echo -e " TROJAN WS TLS LINK :"
echo -e " ${ws_tls_link}"
echo -e "-------------------------------"
echo -e " TROJAN GRPC LINK :"
echo -e " ${grpc_link}"
echo -e "==============================="
}

function deltr(){
clear

IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)

# // Start
CLIENT_001=$(grep -c -E "^Trojan " "/etc/xray/trojan-client.conf")
echo "    =================================================="
echo "              LIST TROJAN CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^Trojan " "/etc/xray/trojan-client.conf" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_002} -ge 1 && ${CLIENT_002} -le ${CLIENT_001} ]]; do
    if [[ ${CLIENT_002} == '1' ]]; then
        echo "    =================================================="
        read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002
    else
        echo "    =================================================="
        read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002
    fi
done

# // String For Username && Expired Date
client=$(grep "^Trojan " "/etc/xray/trojan-client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p)
expired=$(grep "^Trojan " "/etc/xray/trojan-client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p)

printf "y\n" | cp /etc/xray/config/xray/tls.json /etc/xray/xray-cache/cache-nya.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[1].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[4].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json

sed -i "/\b$client\b/d" /etc/xray/trojan-client.conf
systemctl restart xray@tls
}

function renewtr(){
clear

IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)

# // Start
CLIENT_001=$(grep -c -E "^Trojan " "/etc/xray/trojan-client.conf")
echo "    =================================================="
echo "              LIST TROJAN CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^Trojan " "/etc/xray/trojan-client.conf" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_002} -ge 1 && ${CLIENT_002} -le ${CLIENT_001} ]]; do
    if [[ ${CLIENT_002} == '1' ]]; then
        echo "    =================================================="
        read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002
    else
        echo "    =================================================="
        read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002
    fi
done

# // String For Username && Expired Date
client=$(grep "^Trojan " "/etc/xray/trojan-client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p)
expired=$(grep "^Trojan " "/etc/xray/trojan-client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p)
uuidnta=$(grep "^Trojan " "/etc/xray/trojan-client.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_002}"p)

# // Extending Days
clear
read -p "Expired  : " Jumlah_Hari
if [[ $Jumlah_Hari == "" ]]; then
    clear
    echo -e "${FAIL} Mohon Masukan Jumlah Hari perpanjangan !"
    exit 1
fi

# // Date Configuration
now=$(date +%Y-%m-%d)
d1=$(date -d "$expired" +%s)
d2=$(date -d "$now" +%s)
exp2=$(((d1 - d2) / 86400))
exp3=$(($exp2 + $Jumlah_Hari))
exp4=$(date -d "$exp3 days" +"%Y-%m-%d")

# // Input To System Configuration
sed -i "/\b$client\b/d" /etc/xray/trojan-client.conf
echo -e "Trojan $client $exp4 $uuidnta" >>/etc/xray/trojan-client.conf

# // Clear
clear

# // Successfull
echo -e "${OKEY} User ( ${YELLOW}${client}${NC} ) Renewed Then Expired On ( ${YELLOW}$exp4${NC} )"

clear
echo -e "${OKEY} Username ( ${YELLOW}$client${NC} ) Has Been Removed !"
}

echo -e ""
echo -e " ${YELLOW} ----------------=[${NC} ${RED}PANEL XRAY TROJAN${NC} ${YELLOW}]=---------------- ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT})${NC} ${LIGHT}CREATE USER TROJAN${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT})${NC} ${LIGHT}DELETE USER TROJAN${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT})${NC} ${LIGHT}RENEW USER TROJAN${NC}"
echo -e " ${YELLOW} ------------------------------------------------------- ${NC}"
echo -e "       ${GREEN} x${NC}${LIGHT})${NC} ${LIGHT}EXIT${NC}"
echo -e " ${YELLOW} ------------------------------------------------------- ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-3 or type x to return to main menu] : " menutr
echo -e ""
case $menutr in
1)
addtr
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-tr
;;
2)
deltr
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-tr
;;
3)
renewtr
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
