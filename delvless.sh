#!/bin/bash

function import_data() {
    export RED="\033[0;31m"
    export GREEN="\033[0;32m"
    export YELLOW="\033[0;33m"
    export BLUE="\033[0;34m"
    export PURPLE="\033[0;35m"
    export CYAN="\033[0;36m"
    export LIGHT="\033[0;37m"
    export NC="\033[0m"
    export ERROR="[${RED} ERROR ${NC}]"
    export INFO="[${YELLOW} INFO ${NC}]"
    export FAIL="[${RED} FAIL ${NC}]"
    export OKEY="[${GREEN} OKEY ${NC}]"
    export PENDING="[${YELLOW} PENDING ${NC}]"
    export SEND="[${YELLOW} SEND ${NC}]"
    export RECEIVE="[${YELLOW} RECEIVE ${NC}]"
    export RED_BG="\e[41m"
    export BOLD="\e[1m"
    export WARNING="${RED}\e[5m"
    export UNDERLINE="\e[4m"
}

import_data
IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)
clear

# // Start
CLIENT_001=$(grep -c -E "^Vless " "/etc/xray/vless-client.conf")
echo "    =================================================="
echo "              LIST VLESS CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^Vless " "/etc/xray/vless-client.conf" | cut -d ' ' -f 2-3 | nl -s ') '
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
client=$(grep "^Vless " "/etc/xray/vless-client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p)
expired=$(grep "^Vless " "/etc/xray/vless-client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p)

cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[3].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[6].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/nontls.json | jq 'del(.inbounds[1].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/nontls.json.tmp && mv /etc/xray/config/xray/nontls.json.tmp /etc/xray/config/xray/nontls.json

sed -i "/\b$client\b/d" /etc/xray/vless-client.conf
systemctl restart xray@tls
systemctl restart xray@nontls

clear
echo -e "${OKEY} Username ( ${YELLOW}$client${NC} ) Has Been Removed !"
