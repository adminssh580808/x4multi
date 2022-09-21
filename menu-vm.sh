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

function addvm(){
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
if [[ "$(cat /etc/xray/vmess-client.conf | grep -w ${username})" != "" ]]; then
    clear
    echo -e "${FAIL} User [ ${username} ] sudah ada !"
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
nontls_port=$(cat /etc/xray/config/xray/nontls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g')

# // Input Your Data to server
cat /etc/xray/config/xray/tls.json | jq '.inbounds[2].settings.clients += [{"id": "'${uuid}'","email": "'${username}'","alterid": '"0"'}]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq '.inbounds[5].settings.clients += [{"id": "'${uuid}'","email": "'${username}'","alterid": '"0"'}]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/nontls.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${username}'","alterid": '"0"'}]' >/etc/xray/config/xray/nontls.json.tmp && mv /etc/xray/config/xray/nontls.json.tmp /etc/xray/config/xray/nontls.json
echo -e "Vmess $username $exp $uuid" >>/etc/xray/vmess-client.conf

cat >/etc/xray/xray-cache/vmess-tls-gun-$username.json <<END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"grpc","path":"vmess-grpc","port":"${tls_port}","ps":"${username}","scy":"none","sni":"","tls":"tls","type":"gun","v":"2"}
END

cat >/etc/xray/xray-cache/vmess-tls-ws-$username.json <<END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"ws","path":"/vmess","port":"${tls_port}","ps":"${username}","scy":"none","sni":"${domain}","tls":"tls","type":"","v":"2"}
END

cat >/etc/xray/xray-cache/vmess-nontls-$username.json <<END
{"add":"${domain}","aid":"0","host":"","id":"${uuid}","net":"ws","path":"/vmess","port":"${nontls_port}","ps":"${username}","scy":"none","sni":"","tls":"","type":"","v":"2"}
END

# // Vmess Link
grpc_link="vmess://$(base64 -w 0 /etc/xray/xray-cache/vmess-tls-gun-$username.json)"
ws_tls_link="vmess://$(base64 -w 0 /etc/xray/xray-cache/vmess-tls-ws-$username.json)"
ws_nontls_link="vmess://$(base64 -w 0 /etc/xray/xray-cache/vmess-nontls-$username.json)"

# // Restarting XRay Service
systemctl restart xray@tls
systemctl restart xray@nontls

# // Success
clear
echo -e "==============================="
echo -e "     VMESS ACCOUNT DETAILS"
echo -e "==============================="
echo -e " ISP         : ${ISPNYA}"
echo -e " Remarks     : ${username}"
echo -e " IP          : ${IPNYA}"
echo -e " Address     : ${domain}"
echo -e " Port TLS    : ${tls_port}"
echo -e " Port NonTLS : ${nontls_port}"
echo -e " UUID        : ${uuid}"
echo -e " Path WS     : /vmess"
echo -e " ServiceName : vmess-grpc"
echo -e " Expired On  : ${exp}"
echo -e "==============================="
echo -e " VMESS WS TLS LINK :"
echo -e " ${ws_tls_link}"
echo -e "==============================="
echo -e " VMESS WS NTLS LINK :"
echo -e " ${ws_nontls_link}"
echo -e "==============================="
echo -e " VMESS GRPC LINK"
echo -e " ${grpc_link}"
echo -e "==============================="
}

function delvm(){
clear

IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)

# // Start
CLIENT_001=$(grep -c -E "^Vmess " "/etc/xray/vmess-client.conf")
echo "    =================================================="
echo "              LIST VMESS CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^Vmess " "/etc/xray/vmess-client.conf" | cut -d ' ' -f 2-3 | nl -s ') '
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
client=$(grep "^Vmess " "/etc/xray/vmess-client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p)
expired=$(grep "^Vmess " "/etc/xray/vmess-client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p)

cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[2].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[5].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/nontls.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/nontls.json.tmp && mv /etc/xray/config/xray/nontls.json.tmp /etc/xray/config/xray/nontls.json
rm -f /etc/xray/xray-cache/vmess-tls-gun-$client.json /etc/xray/xray-cache/vmess-tls-ws-$client.json /etc/xray/xray-cache/vmess-nontls-$client.json
sed -i "/\b$client\b/d" /etc/xray/vmess-client.conf
systemctl restart xray@tls
systemctl restart xray@nontls

clear
echo -e "${OKEY} Username ( ${YELLOW}$client${NC} ) Has Been Removed !"
}

function renewvm(){
clear

IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)

# // Start
CLIENT_001=$(grep -c -E "^Vmess " "/etc/xray/vmess-client.conf")
echo "    =================================================="
echo "               LIST VMESS CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^Vmess " "/etc/xray/vmess-client.conf" | cut -d ' ' -f 2-3 | nl -s ') '
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
client=$(grep "^Vmess " "/etc/xray/vmess-client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p)
expired=$(grep "^Vmess " "/etc/xray/vmess-client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p)
uuidnta=$(grep "^Vmess " "/etc/xray/vmess-client.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_002}"p)

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
sed -i "/\b$client\b/d" /etc/xray/vmess-client.conf
echo -e "Vmess $client $exp4 $uuidnta" >>/etc/xray/vmess-client.conf

# // Clear
clear

# // Successfull
echo -e "${OKEY} User ( ${YELLOW}${client}${NC} ) Renewed Then Expired On ( ${YELLOW}$exp4${NC} )"
}

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
addvm
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-vm
;;
2)
delvm
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-vm
;;
3)
renewvm
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
