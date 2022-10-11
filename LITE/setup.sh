#!/bin/bash

source /root/scvpn_data/secure.dat;

# // Checking Your Running Or Root or no
if [[ "${EUID}" -ne 0 ]]; then
echo -e " ${ERROR} Please run this script as root user";
exit 1
fi

