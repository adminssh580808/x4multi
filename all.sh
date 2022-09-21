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
tls_port=$(cat /etc/xray/config/xray/tls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g')
nontls_port=$(cat /etc/xray/config/xray/nontls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g')

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

# // Input Your Data to server
cat /etc/xray/config/xray/tls.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","flow": "xtls-rprx-direct","email":"'${username}'","level": 0 }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq '.inbounds[1].settings.clients += [{"password": "'${uuid}'","email":"'${username}'" }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq '.inbounds[4].settings.clients += [{"password": "'${uuid}'","email":"'${username}'" }]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
echo -e "Trojan $username $exp $uuid" >>/etc/xray/trojan-client.conf

# // Make Configruation Link
tgrpc_link="trojan://${uuid}@${domain}:${tls_port}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc#${username}"
ttcp_tls_link="trojan://${uuid}@${domain}:${tls_port}?security=tls&headerType=none&type=tcp#${username}"
tws_tls_link="trojan://${uuid}@${domain}:${tls_port}?path=%2Ftrojan&security=tls&type=ws#${username}"

# // Input Your Data to server
cat /etc/xray/config/xray/tls.json | jq '.inbounds[3].settings.clients += [{"id": "'${uuid}'","email": "'${username}'"}]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq '.inbounds[6].settings.clients += [{"id": "'${uuid}'","email": "'${username}'"}]' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/nontls.json | jq '.inbounds[1].settings.clients += [{"id": "'${uuid}'","email": "'${username}'"}]' >/etc/config/config/xray/nontls.json.tmp && mv /etc/xray/config/xray/nontls.json.tmp /etc/xray/config/xray/nontls.json
echo -e "Vless $username $exp $uuid" >>/etc/xray/vless-client.conf

# // Vless Link
vless_nontls="vless://${uuid}@${domain}:${nontls_port}?path=%2Fvless&security=none&encryption=none&type=ws#${username}"
vless_tls="vless://${uuid}@${domain}:${tls_port}?path=%2Fvless&security=tls&encryption=none&type=ws#${username}"
vless_grpc="vless://${uuid}@${domain}:${tls_port}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc#${username}"

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
echo -e "========================================="
echo -e "         XRAY ACCOUNT DETAILS"
echo -e "========================================="
echo -e " ISP              : ${ISPNYA}"
echo -e " Remarks          : ${username}"
echo -e " IP               : ${IPNYA}"
echo -e " Address          : ${domain}"
echo -e " Port TLS         : ${tls_port}"
echo -e " Port Non TLS     : ${tls_port}"
echo -e " Password / UUID  : ${uuid}"
echo -e " Path SS WS       : /ss-ws"
echo -e " ServiceName GRPC : ss-grpc"
echo -e " Path Trojan WS   : /trojan"
echo -e " ServiceName GRPC : trojan-grpc"
echo -e " Path Vless WS    : /vless"
echo -e " ServiceName GRPC : vless-grpc"
echo -e " Path Vmess WS    : /vmess"
echo -e " ServiceName GRPC : vmess-grpc"
echo -e " Expired On       : ${exp}"
echo -e "========================================="
echo -e " SHADOWSOCKS GRPC LINK :"
echo -e " ${shadowsockslink1}"
echo -e "-----------------------------------------"
echo -e " SHADOWSOCKS WS TLS LINK :"
echo -e " ${shadowsockslink}"
echo -e "-----------------------------------------"
echo -e " CONFIG SS WS TLS   :" 
echo -e " http://${domain}:81/ss-ws-$username.txt"
echo -e " CONFIG SS GRPC TLS :"
echo -e " http://${domain}:81/ss-grpc-$username.txt"
echo -e "========================================="
echo -e " TROJAN TCP TLS LINK :"
echo -e " ${ttcp_tls_link}"
echo -e "-----------------------------------------"
echo -e " TROJAN WS TLS LINK :"
echo -e " ${tws_tls_link}"
echo -e "-----------------------------------------"
echo -e " TROJAN GRPC LINK :"
echo -e " ${tgrpc_link}"
echo -e "========================================="
echo -e " VLESS WS TLS LINK :"
echo -e " ${vless_tls}"
echo -e "-----------------------------------------"
echo -e " VLESS WS NTLS LINK :"
echo -e " ${vless_nontls}"
echo -e "-----------------------------------------"
echo -e " VLESS GRPC LINK :"
echo -e " ${vless_grpc}"
echo -e "========================================="
echo -e " VMESS WS TLS LINK :"
echo -e " ${ws_tls_link}"
echo -e "-----------------------------------------"
echo -e " VMESS WS NTLS LINK :"
echo -e " ${ws_nontls_link}"
echo -e "-----------------------------------------"
echo -e " VMESS GRPC LINK"
echo -e " ${grpc_link}"
echo -e "========================================="
