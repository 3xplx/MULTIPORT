#!/bin/bash
clear;

source /root/scvpn_data/scvpn_data;
domain=$( cat /root/scvpn_data/domain );
tr="443"


until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
read -rp "User: " -e user
user_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${user_EXISTS} == '1' ]]; then
clear
echo "A client with the specified name was already created, please choose another name."
read -n 1 -s -r -p "Press any key to back on menu"
menu
fi
done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojanws$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

systemctl restart xray
trojanlink="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
trojanlink1="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${user}"
clear

echo -e "User       : ${user}" 
echo -e "Expired On : $exp" 
echo -e "Host/IP    : ${domain}" 
echo -e "Port       : ${tr}" 
echo -e "Uuid       : ${uuid}" 
echo -e ""
echo -e "Link WS : ${trojanlink}"
echo -e ""
echo -e "Link GRPC : ${trojanlink1}" 
echo "" 
read -n 1 -s -r -p "Press any key to back on menu"
menu
