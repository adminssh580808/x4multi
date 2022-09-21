#!/bin/bash
clear

read -rp "Input ur domain : " -e domain

echo "$domain" >/etc/xray/domain.conf
clear
xray-cert
read -p "Enter to reboot system"
reboot

