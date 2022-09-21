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

function addss(){
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
if [[ "$(cat /etc/xray/ss-client.conf | grep -w ${username})" != "" ]]; then
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
tls_port=443

# // Input Your Data to server
cat /etc/xray/config/xray/tls.json | jq '.inbounds[7].settings.clients += [{"method": "'"aes-256-gcm"'","password": "'${uuid}'","email":"'${username}'" }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq '.inbounds[8].settings.clients += [{"method": "'"aes-256-gcm"'","password": "'${uuid}'","email":"'${username}'" }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
echo -e "Shadowsocks $username $exp $uuid" >>/etc/xray/ss-client.conf

# // Make Configruation Link
cipher="aes-256-gcm"
code=`echo -n $cipher:$uuid | base64`;
shadowsockslink="ss://${code}@$domain:$tls?plugin=xray-plugin;mux=0;path=/ss-ws;host=$domain;tls#${username}"
shadowsockslink1="ss://${code}@$domain:$tls?plugin=xray-plugin;mux=0;serviceName=ss-grpc;host=$domain;tls#${username}"

# // Restarting XRay Service
systemctl restart xray@tls
cat > /home/vps/public_html/ss-ws-$username.txt <<-END
{ 
 "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  },
 "inbounds": [
   {
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "$cipher",
            "password": "$uuid",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "isi_bug_disini"
        },
        "wsSettings": {
          "headers": {
            "Host": "$domain"
          },
          "path": "/ss-ws"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
"rules": []
  },
  "stats": {}
}
END
cat > /home/vps/public_html/ss-grpc-$username.txt <<-END
{
    "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  },
 "inbounds": [
   {
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "$cipher",
            "password": "$uuid",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
          "serviceName": "ss-grpc"
        },
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "isi_bug_disini"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
"rules": []
  },
  "stats": {}
}
END
# // Success
clear
echo -e "  SHADOWSOCKS ACCOUNT DETAILS"
echo -e "==============================="
echo -e " ISP         : ${ISPNYA}"
echo -e " Remarks     : ${username}"
echo -e " IP          : ${IPNYA}"
echo -e " Address     : ${domain}"
echo -e " Port        : ${tls_port}"
echo -e " Password    : ${uuid}"
echo -e " Path WS     : /ss-ws"
echo -e " ServiceName : ss-grpc"
echo -e " Expired On  : ${exp}"
echo -e "==============================="
echo -e " SHADOWSOCKS GRPC LINK :"
echo -e " ${shadowsockslink1}"
echo -e "==============================="
echo -e " SHADOWSOCKS WS TLS LINK :"
echo -e " ${shadowsockslink}"
echo -e "==============================="
echo -e " CONFIG WS TLS   :" 
echo -e " http://${domain}:81/ss-ws-$username.txt"
echo -e " CONFIG GRPC TLS :"
echo -e " http://${domain}:81/ss-grpc-$username.txt"
echo -e "==============================="
}

function delss(){
clear

IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)

# // Start
CLIENT_001=$(grep -c -E "^Shadowsocks " "/etc/xray/ss-client.conf")
echo "    =================================================="
echo "              LIST SHADOWSOCKS CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^Shadowsocks " "/etc/xray/ss-client.conf" | cut -d ' ' -f 2-3 | nl -s ') '
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
client=$(grep "^Shadowsocks " "/etc/xray/ss-client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p)
expired=$(grep "^Shadowsocks " "/etc/xray/ss-client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p)

printf "y\n" | cp /etc/xray/config/xray/tls.json /etc/xray/xray-cache/cache-nya.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[7].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[8].settings.clients[] | select(.email == "'${client}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json

sed -i "/\b$client\b/d" /etc/xray/ss-client.conf
rm -f /home/vps/public_html/ss-gr-${client}.txt
rm -f /home/vps/public_html/ss-ws-${client}.txt
systemctl restart xray@tls

clear
echo -e "${OKEY} Username ( ${YELLOW}$client${NC} ) Has Been Removed !"
}

function renewss(){
clear

IPNYA=$(wget --inet4-only -qO- https://ipinfo.io/ip)
ISPNYA=$(wget --inet4-only -qO- https://ipinfo.io/org | cut -d " " -f 2-100)

# // Start
CLIENT_001=$(grep -c -E "^Shadowsocks " "/etc/xray/ss-client.conf")
echo "    =================================================="
echo "              LIST SHADOWSOCKS CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^Shadowsocks " "/etc/xray/ss-client.conf" | cut -d ' ' -f 2-3 | nl -s ') '
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
client=$(grep "^Shadowsocks " "/etc/xray/ss-client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p)
expired=$(grep "^Shadowsocks " "/etc/xray/ss-client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p)
uuidnta=$(grep "^Shadowsocks " "/etc/xray/ss-client.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_002}"p)

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
sed -i "/\b$client\b/d" /etc/xray/ss-client.conf
echo -e "Shadowsocks $client $exp4 $uuidnta" >>/etc/xray/ss-client.conf

# // Clear
clear

# // Successfull
echo -e "${OKEY} User ( ${YELLOW}${client}${NC} ) Renewed Then Expired On ( ${YELLOW}$exp4${NC} )"
}

echo -e ""
echo -e " ${YELLOW} --------------=[${NC} ${RED}PANEL XRAY SHADOWSOCKS${NC} ${YELLOW}]=-------------- ${NC}"
echo -e "    ${GREEN} 1${NC}${LIGHT})${NC} ${LIGHT}CREATE USER SHADOWSOCKS${NC}"
echo -e "    ${GREEN} 2${NC}${LIGHT})${NC} ${LIGHT}DELETE USER SHADOWSOCKS${NC}"
echo -e "    ${GREEN} 3${NC}${LIGHT})${NC} ${LIGHT}RENEW USER SHADOWSOCKS${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e "       ${GREEN} x${NC}${LIGHT})${NC} ${LIGHT}EXIT${NC}"
echo -e " ${YELLOW} -------------------------------------------------------- ${NC}"
echo -e ""
echo -e "    ${LIGHT} Select From Options ${NC}"
read -p "     [1-3 or type x to return to main menu] : "  menuss
echo -e ""
case $menuss in
1)
clear
addss
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-ss
;;
2)
clear
delss
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-ss
;;
3)
clear
renewss
echo ""
read -p "Click Enter To Return To The Menu..."
clear
menu-ss
;;
x)
menu
;;
*)
menu-ss
;;
esac
