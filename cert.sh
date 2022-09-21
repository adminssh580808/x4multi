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
