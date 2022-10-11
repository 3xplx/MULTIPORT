#!/bin/bash
clear;


# // Make Folder
rm -rf /root/scvpn_data/ > /dev/null 2>&1
mkdir -p /root/scvpn_data/ > /dev/null 2>&1
mkdir -p /etc/xray/ > /dev/null 2>&1

## // Running Update & install Requirement
apt update -y;
apt upgrade -y;
apt autoremove -y;
apt dist-upgrade -y;
apt install jq -y;
apt install wget -y;
apt install nano -y;
apt install curl -y;

# // Removing Apache / Nginx if exist
apt remove --purge nginx -y;
apt remove --purge apache2 -y;
apt autoremove -y;

# // Installing Requirement
apt install net-tools -y;
apt install netfilter-persistent -y;
apt install openssl -y;
apt install iptables -y;
apt install iptables-persistent -y;
apt autoremove -y;

# // Installing BBR & FQ
cat > /etc/sysctl.conf << END
# Sysctl Config By Nazren Naz @ dotycat.com
# // Enable IPv4 Forward
net.ipv4.ip_forward=1

# // Disable IPV6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# // Enable bbr & fq for optimization
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
END
sysctl -p;

# // Configuring Socat & Remove nginx & apache if installed
clear;
apt install socat -y;
apt install sudo -y;

# // Stopping Service maybe is installed
systemctl stop nginx > /dev/null 2>&1
systemctl stop apache2 > /dev/null 2>&1

# // Kill port 80 & 443 if already used
lsof -t -i tcp:80 -s tcp:listen | xargs kill > /dev/null 2>&1
lsof -t -i tcp:443 -s tcp:listen | xargs kill > /dev/null 2>&1

MYIP=$(wget -qO- ipinfo.io/ip);
dataV=$( curl -sS https://raw.githubusercontent.com/3xplx/MULTIPORT/main/LITE/scvpn_data  )
echo "$dataV" > /root/scvpn_data/scvpn_data
echo "IP='$MYIP'" >> /root/scvpn_data/scvpn_data
source /root/scvpn_data/scvpn_data;

# // Checking Your Running Or Root or no
if [[ "${EUID}" -ne 0 ]]; then
echo -e "${ERROR} Please run this script as root user";
exit 1
fi

clear
read -p "Input Your Domain : " domain
domain=$( echo $domain | sed 's/ //g' );

if [[ $domain == "" ]]; then
clear;
echo -e "${ERROR} Domain cannot be empty !";
exit 1;
fi

echo "$domain" > /root/scvpn_data/domain;
domain=$( cat /root/scvpn_data/domain );
echo -e "${INFO} Domain Added Successfully !";
sleep 2
clear;
echo -e "${OKEY} Starting Generating Certificate";
rm -rf /root/.acme.sh;
mkdir -p /root/.acme.sh;
wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/3xplx/MULTIPORT/main/RESOURCE/acme.sh";
chmod +x /root/.acme.sh/acme.sh;
sudo /root/.acme.sh/acme.sh --register-account -m vpn-script@wildydev21.com;
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256;
# // Success
sleep 3
clear
echo -e "${OKEY} Certificate Created Successfully";
echo -e "${OKEY} Your Domain : $domain";
echo -e "${INFO} Installation Will Continue In 5 Second"
sleep 5

## // Installing Requirement
clear
echo -e "${INFO} Installing Requirement";
sleep 2
wget -q -O /root/requirement.sh "https://raw.githubusercontent.com/3xplx/MULTIPORT/main/LITE/requirement.sh";
chmod +x requirement.sh;
/root/requirement.sh;

## // Install Nginx
clear
echo -e "${INFO} Installing Nginx";
sleep 2
wget -q -O /root/nginx.sh "https://raw.githubusercontent.com/3xplx/MULTIPORT/main/LITE/nginx.sh";
chmod +x nginx.sh;
/root/nginx.sh;

## // Install Xray
clear
echo -e "${INFO} Installing Xray";
sleep 2
wget -q -O /root/ins-xray.sh "https://raw.githubusercontent.com/3xplx/MULTIPORT/main/LITE/XRAY/ins-xray.sh";
chmod +x ins-xray.sh;
/root/ins-xray.sh;


## // Install Xray
clear
echo -e "${INFO} Installing Vps Menu";
sleep 2
wget -q -O /root/ins-xray.sh "https://raw.githubusercontent.com/3xplx/MULTIPORT/main/LITE/XRAY/ins-menu.sh";
chmod +x ins-menu.sh;
/root/ins-menu.sh;


clear
echo -e "${INFO} The installation completed successfully";
echo -e ""
echo -ne "$INFO Do you want to reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi



