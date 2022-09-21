# xray-install

apt --fix-missing update && apt update && apt upgrade -y && apt install -y wget screen && update-grub && reboot

sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && wget -q https://raw.githubusercontent.com/adminssh580808/JKW/main/setup.sh && chmod +x setup.sh && screen -S setup ./setup.sh
