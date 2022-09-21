#!/bin/bash

# SHADOWSOCKS
datas=( `cat /etc/xray/ss-client.conf | grep '^Shadowsocks' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${datas[@]}"
do
exps=$(grep -w "^Shadowsocks $user" "/etc/xray/ss-client.conf" | cut -d ' ' -f 3)
d1=$(date -d "$exps" +%s)
d2=$(date -d "$now" +%s)
if [[ $d1 -eq $d2  ]]; then
printf "y\n" | cp /etc/xray/config/xray/tls.json /etc/xray/xray-cache/cache-nya.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[7].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[8].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json

sed -i "/\b$user\b/d" /etc/xray/ss-client.conf
rm -f /home/vps/public_html/ss-grpc-${user}.txt
rm -f /home/vps/public_html/ss-ws-${user}.txt
fi
done


# TROJAN
datat=( `cat /etc/xray/trojan-client.conf | grep '^Trojan' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${datat[@]}"
do
expt=$(grep -w "^Trojan $user" "/etc/xray/trojan-client.conf" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
printf "y\n" | cp /etc/xray/config/xray/tls.json /etc/xray/xray-cache/cache-nya.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[1].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[4].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json

sed -i "/\b$user\b/d" /etc/xray/trojan-client.conf
fi
done

# VLESS 
datavl=( `cat /etc/xray/vless-client.conf | grep '^Vless' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${datavl[@]}"
do
expvl=$(grep -w "^Vless $user" "/etc/xray/vless-client.conf" | cut -d ' ' -f 3)
d1=$(date -d "$expvl" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[3].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[6].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/nontls.json | jq 'del(.inbounds[1].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/nontls.json.tmp && mv /etc/xray/config/xray/nontls.json.tmp /etc/xray/config/xray/nontls.json

sed -i "/\b$user\b/d" /etc/xray/vless-client.conf
fi
done

# VMESS
datav=( `cat /etc/xray/vmess-client.conf | grep '^Vmess' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${datav[@]}"
do
expv=$(grep -w "^Vmess $user" "/etc/xray/vmess-client.conf" | cut -d ' ' -f 3)
d1=$(date -d "$expv" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[2].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/tls.json | jq 'del(.inbounds[5].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/tls.json.tmp && mv /etc/xray/config/xray/tls.json.tmp /etc/xray/config/xray/tls.json
cat /etc/xray/config/xray/nontls.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${user}'"))' >/etc/xray/config/xray/nontls.json.tmp && mv /etc/xray/config/xray/nontls.json.tmp /etc/xray/config/xray/nontls.json
rm -f /etc/xray/xray-cache/vmess-tls-gun-$user.json /etc/xray/xray-cache/vmess-tls-ws-$user.json /etc/xray/xray-cache/vmess-nontls-$user.json
sed -i "/\b$user\b/d" /etc/xray/vmess-client.conf
systemctl restart xray@tls
systemctl restart xray@nontls
fi
done
