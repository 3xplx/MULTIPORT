#!/bin/bash

source /root/scvpn_data/scvpn_data;

# // Installing Update
apt update -y;
apt upgrade -y;
apt dist-upgrade -y;
apt remove --purge ufw firewalld exim4 -y;
apt autoremove -y;
apt clean -y;

# // Install Requirement Tools
apt install python -y;
apt install make-guile -y;
apt install make -y;
apt install cmake -y;
apt install coreutils -y;
apt install rsyslog -y;
apt install net-tools -y;
apt install zip -y;
apt install unzip -y;
apt install nano -y;
apt install sed -y;
apt install gnupg -y;
apt install gnupg1 -y;
apt install bc -y;
apt install jq -y;

# // remove cache nd resume installing
apt autoremove -y; 
apt clean -y
apt install apt-transport-https -y;
apt install build-essential -y;
apt install dirmngr -y;
apt install libxml-parser-perl -y;
apt install git -y;
apt install lsof -y;
apt install libsqlite3-dev -y;
apt install libz-dev -y;
apt install gcc -y;
apt install g++ -y;
apt install libreadline-dev -y;
apt install zlib1g-dev -y;
apt install libssl-dev -y;

# // Installing neofetch
wget -q -O /usr/local/sbin/neofetch "https://raw.githubusercontent.com/3xplx/MULTIPORT/main/RESOURCE/neofetch"; chmod +x /usr/local/sbin/neofetch;

# // Setting Time
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;

# // Getting Ip Route
export NET=$(ip route show default | awk '{print $5}');
export MYIP2="s/xxxxxxxxx/$IP/g";

# // Installing Vnstat 2.9
apt install vnstat -y;
/etc/init.d/vnstat stop;
wget -q -O vnstat.zip "https://raw.githubusercontent.com/3xplx/MULTIPORT/main/RESOURCE/vnstat.zip";
unzip -o vnstat.zip > /dev/null 2>&1;
cd vnstat;
chmod +x configure;
./configure --prefix=/usr --sysconfdir=/etc --disable-dependency-tracking && make && make install;
cd;
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf;
chown vnstat:vnstat /var/lib/vnstat -R;
systemctl disable vnstat;
systemctl enable vnstat;
systemctl restart vnstat;
/etc/init.d/vnstat restart;
rm -r -f vnstat;
rm -f vnstat.zip;


# // Block Torrent using iptables
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP;
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP;
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP;
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP;
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP;
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP;
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP;
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save;
netfilter-persistent reload;


# // Installing Rclone
curl -s https://rclone.org/install.sh | bash > /dev/null 2>&1
printf "q\n" | rclone config > /dev/null 2>&1

# // Installing Fail2ban
apt install fail2ban -y;
/etc/init.d/fail2ban restart;

# // Remove not used file
rm -f /root/requirement.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed Requirement Tools";
sleep 5
