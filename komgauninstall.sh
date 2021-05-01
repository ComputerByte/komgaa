#!/bin/bash

# Script by @ComputerByte 
# For komga Uninstalls

# Log to Swizzin.log
export log=/root/logs/swizzin.log
touch $log

systemctl disable --now -q komga
rm /etc/systemd/system/komga.service
systemctl daemon-reload -q

if [[ -f /install/.nginx.lock ]]; then
    rm /etc/nginx/apps/komga.conf
    systemctl reload nginx
fi

rm /install/.komga.lock
rm "/opt/swizzin/static/img/apps/komga.png"
rm -rf "/opt/komga/"

sed -e "s/class komga_meta://g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    name = \"komga\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    pretty_name = \"Komga\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    baseurl = \"\/komga\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    systemd = \"komga\"//g" -i /opt/swizzin/core/custom/profiles.py
sed -e "s/    img = \"komga\"//g" -i /opt/swizzin/core/custom/profiles.py