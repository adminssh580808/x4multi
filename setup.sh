#!/bin/bash

clear

function import_string() {
    export SCRIPT_URL='https://raw.githubusercontent.com/adminssh580808/JKW/main'
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

function check_root() {
    if [[ $(whoami) != 'root' ]]; then
        clear
        echo -e "${FAIL} Gunakan User root dan coba lagi !"
        exit 1
    else
        export ROOT_CHK='true'
    fi
}

function check_architecture() {
    if [[ $(uname -m) == 'x86_64' ]]; then
        export ARCH_CHK='true'
    else
        clear
        echo -e "${FAIL} Architecture anda tidak didukung !"
        exit 1
    fi
}

function install_requirement() {
    read -rp "Input ur domain : " -e hostname
    # // Membuat Folder untuk menyimpan data utama
    mkdir -p /etc/xray/
    mkdir -p /etc/xray/core/
    mkdir -p /etc/xray/log/
    mkdir -p /etc/xray/config/
    echo "$hostname" >/etc/xray/domain.conf

    # // Mengupdate repo dan hapus program yang tidak dibutuhkan
    apt update -y
    apt upgrade -y
    apt dist-upgrade -y
    apt autoremove -y
    apt clean -y

    # // Menghapus apache2 nginx sendmail ufw firewall dan exim4 untuk menghindari port nabrak
    apt remove --purge nginx apache2 sendmail ufw firewalld exim4 -y >/dev/null 2>&1
    apt autoremove -y
    apt clean -y

    # // Menginstall paket yang di butuhkan
    apt install build-essential apt-transport-https -y
    apt install zip unzip nano net-tools make git lsof wget curl jq bc gcc make cmake neofetch htop libssl-dev socat sed zlib1g-dev libsqlite3-dev libpcre3 libpcre3-dev libgd-dev -y
	apt-get install uuid-runtime

    # // Menghentikan Port 443 & 80 jika berjalan
    lsof -t -i tcp:80 -s tcp:listen | xargs kill >/dev/null 2>&1
    lsof -t -i tcp:443 -s tcp:listen | xargs kill >/dev/null 2>&1

    # // Membuat sertifikat letsencrypt untuk xray
    rm -rf /root/.acme.sh
    mkdir -p /root/.acme.sh
    wget -q -O /root/.acme.sh/acme.sh "${SCRIPT_URL}/acme.sh"
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --register-account -m tambarin45@gmail.com
    /root/.acme.sh/acme.sh --issue -d $hostname --standalone -k ec-256 -ak ec-256

    # Menyetting waktu menjadi waktu WIB
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

    # // Install nginx
    apt-get install libpcre3 libpcre3-dev zlib1g-dev dbus -y
    echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" |
        sudo tee /etc/apt/sources.list.d/nginx.list
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
    apt update
    apt install nginx -y
    cat > /etc/nginx/nginx.conf <<END
user www-data;

worker_processes 1;
pid /var/run/nginx.pid;

events {
	multi_accept on;
    worker_connections 1024;
}

http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;
	autoindex on;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    access_log /var/log/nginx/access.log;
  	error_log /var/log/nginx/error.log error;
    client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;
	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;
	fastcgi_read_timeout 600;
	set_real_ip_from 204.93.240.0/24;
	set_real_ip_from 204.93.177.0/24;
	set_real_ip_from 199.27.128.0/21;
	set_real_ip_from 173.245.48.0/20;
	set_real_ip_from 103.21.244.0/22;
	set_real_ip_from 103.22.200.0/22;
	set_real_ip_from 103.31.4.0/22;
	set_real_ip_from 141.101.64.0/18;
	set_real_ip_from 108.162.192.0/18;
	set_real_ip_from 190.93.240.0/20;
	set_real_ip_from 188.114.96.0/20;
	set_real_ip_from 197.234.240.0/22;
	set_real_ip_from 198.41.128.0/17;
	real_ip_header CF-Connecting-IP;
    include /etc/nginx/conf.d/*.conf;
}
END
cd
    cat > /etc/nginx/conf.d/xray.conf <<END
server {
  listen       81;
  server_name  127.0.0.1 localhost;
  root   /home/vps/public_html;

  location / {
    index  index.html index.htm index.php;
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
}

# // Config For GRPC
server {
        listen 127.0.0.1:34804 http2 so_keepalive=on;
        root /home/vps/public_html;
        client_header_timeout 1071906480m;
        keepalive_timeout 1071906480m;
        location /trojan-grpc {
                client_max_body_size 0;
                grpc_set_header X-Real-IP $proxy_add_x_forwarded_for;
                client_body_timeout 1071906480m;
                grpc_read_timeout 1071906480m;
                grpc_pass grpc://127.0.0.1:34805;
        }
        location /vmess-grpc {
                client_max_body_size 0;
                grpc_set_header X-Real-IP $proxy_add_x_forwarded_for;
                client_body_timeout 1071906480m;
                grpc_read_timeout 1071906480m;
                grpc_pass grpc://127.0.0.1:34806;
        }
        location /vless-grpc {
                client_max_body_size 0;
                grpc_set_header X-Real-IP $proxy_add_x_forwarded_for;
                client_body_timeout 1071906480m;
                grpc_read_timeout 1071906480m;
                grpc_pass grpc://127.0.0.1:34807;
        }

        location /ss-grpc {
            if ($request_method != "POST") { 
                return 404;
            }
            client_body_buffer_size 1m;
            client_body_timeout 1h;
            client_max_body_size 0;
            grpc_pass grpc://127.0.0.1:2011;
            grpc_read_timeout 1h;
            grpc_send_timeout 1h;
            grpc_set_header X-Real-IP $remote_addr;
        }
}
END
    rm -rf /etc/nginx/conf.d/default.conf
    systemctl enable nginx
    mkdir -p /home/vps/public_html
    chown -R www-data:www-data /home/vps/public_html
    chmod -R g+rw /home/vps/public_html
    echo "
    <head><meta name="robots" content="noindex" /></head>
    <title>Automatic Script VPS by Sshinjector.net</title>
    <body><pre><center><img src="https://1.bp.blogspot.com/-gpOb09BfB5w/XHpsdAZvDbI/AAAAAAAAAFY/0pJfvL2O3OsMxGVWR--KKXTZ7fmAGgU7wCLcBGAs/s320/faismartlogo.png" data-original-height="120" data-original-width="120" height="320" width="320"><b><br><br><font color="RED" size="50"><b>Setup by: M Fauzan Romandhoni</font><br><font color="BLUE" size="50">Whatsapp: 083875176829</font></b><br><br><font color="GREEN" size="50">SSHINJECTOR.NET</font><br></center></pre></body>
    " >/home/vps/public_html/index.html
    systemctl start nginx

    # // Install Vnstat
    NET=$(ip -o $ANU -4 route show to default | awk '{print $5}')
    apt -y install vnstat
    /etc/init.d/vnstat restart
    apt -y install libsqlite3-dev
    wget -q https://humdi.net/vnstat/vnstat-2.9.tar.gz
    tar zxvf vnstat-2.9.tar.gz
    cd vnstat-2.9
    ./configure --prefix=/usr --sysconfdir=/etc && make && make install
    cd
    vnstat -u -i $NET
    sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
    chown vnstat:vnstat /var/lib/vnstat -R
    systemctl enable vnstat
    /etc/init.d/vnstat restart
    rm -f /root/vnstat-2.9.tar.gz
    rm -rf /root/vnstat-2.9

    # // Install Xray
    wget --inet4-only -O /etc/xray/core/xray.zip "${SCRIPT_URL}/xray.zip"
    cd /etc/xray/core/
    unzip -o xray.zip
    rm -f xray.zip
    cd /root/
    mkdir -p /etc/xray/log/xray/
    mkdir -p /etc/xray/config/xray/
    wget --inet4-only -qO- "${SCRIPT_URL}/tls.json" | jq '.inbounds[0].streamSettings.xtlsSettings.certificates += [{"certificateFile": "'/root/.acme.sh/${hostname}_ecc/fullchain.cer'","keyFile": "'/root/.acme.sh/${hostname}_ecc/${hostname}.key'"}]' >/etc/xray/config/xray/tls.json
    wget --inet4-only -qO- "${SCRIPT_URL}/nontls.json" >/etc/xray/config/xray/nontls.json
    cat > /etc/systemd/system/xray@.service <<END
[Unit]
Description=XRay XTLS Service ( %i )
Documentation=https://github.com/XTLS/Xray-core
After=syslog.target network-online.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/xray/core/xray -c /etc/xray/config/xray/%i.json
LimitNPROC=10000
LimitNOFILE=1000000
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

    systemctl daemon-reload
    systemctl stop xray@tls
    systemctl disable xray@tls
    systemctl enable xray@tls
    systemctl start xray@tls
    systemctl restart xray@tls
    systemctl stop xray@nontls
    systemctl disable xray@nontls
    systemctl enable xray@nontls
    systemctl start xray@nontls
    systemctl restart xray@nontls

    # // Download welcome
    rm -f /root/.bashrc
    echo "clear" >>.bashrc
    echo "neofetch" >>.bashrc
    echo "Type menu To acces Panel" >>.bashrc

    # // Install python2
    apt install python2 -y >/dev/null 2>&1

    # // Download menu
    cd /usr/bin
    wget -q -O xray-cert "${SCRIPT_URL}/cert.sh"
    chmod +x xray-cert
    wget -q -O menu "${SCRIPT_URL}/menu.sh"
    chmod +x menu
    wget -q -O menu-ss "${SCRIPT_URL}/menu-ss.sh"
    chmod +x menu-ss
    wget -q -O menu-tr "${SCRIPT_URL}/menu-tr.sh"
    chmod +x menu-tr
    wget -q -O menu-vl "${SCRIPT_URL}/menu-vl.sh"
    chmod +x menu-vl
    wget -q -O menu-vm "${SCRIPT_URL}/menu-vm.sh"
    chmod +x menu-vm
    wget -q -O run "${SCRIPT_URL}/run.sh"
    chmod +x run
    wget -q -O info "${SCRIPT_URL}/info.sh"
    chmod +x info
    wget -q -O speedtest "${SCRIPT_URL}/speedtest_cli.py"
    chmod +x speedtest
    cd

    cd /usr/bin
    wget -q -O xp "${SCRIPT_URL}/xp.sh"
    chmod +x xp
    cd

    sed -i -e 's/\r$//' xp
    cd

    echo "0 5 * * * root reboot" >> /etc/crontab
    echo "0 0 * * * root xp" >> /etc/crontab
    cd

    mkdir /home/trojan
    mkdir /home/vmess
    mkdir /home/vless
    mkdir /home/shadowsocks
    cat >/home/vps/public_html/trojan.json <<END
{
    "TCP TLS" : "443",
    "WS TLS" : "443"
}
END
    cat >/home/vps/public_html/vmess.json <<END
    {
        "WS TLS" : "443",
        "WS Non TLS" : "80"
    }
END
    cat >/home/vps/public_html/vless.json <<END
    {
        "WS TLS" : "443",
        "WS Non TLS" : "80"
    }
END
    cat >/home/vps/public_html/ss.json <<END
    {
        "WS TLS" : "443",
        "GRPC" : "443"
    }
END

    touch /etc/xray/trojan-client.conf
    touch /etc/xray/vmess-client.conf
    touch /etc/xray/vless-client.conf
    touch /etc/xray/ss-client.conf

    # // Force create folder for fixing account wasted
    mkdir -p /etc/xray/xray-cache/

    # // Setting environment
    echo 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/etc/xray/core:' >/etc/environment
    source /etc/environment

    clear
    rm -rf /root/setup.sh
    
}

function main() {
    import_string
    check_root
    check_architecture
    install_requirement
}

main
sleep 2
echo "Installation Has Been Successful"
