#!/bin/bash
. /etc/swizzin/sources/globals.sh
. /etc/swizzin/sources/functions/utils

# Script by @ComputerByte 
# For Komga Installs

# Log to Swizzin.log
export log=/root/logs/swizzin.log
touch $log
# Set variables
user=$(_get_master_username)

echo_progress_start "Making data directory and owning it to ${user}"
mkdir -p "/opt/komga"
chown -R "$user":"$user" /opt/komga
cd "/opt/komga" || exit
wget "https://github.com/gotson/komga/releases/download/untagged-6ed960e7d43ebfe31fe8/komga-0.90.0.jar" >> $log 2>&1
echo_progress_done "Data Directory created and owned."

echo_progress_start "Installing systemd service file"
cat > /etc/systemd/system/komga.service <<- SERV 
[[Unit]
Description=Komga server

[Service]
WorkingDirectory=/opt/komga/
ExecStart=/usr/bin/java -jar -Xmx4g komga-0.90.0.jar --server.servlet.context-path="/komga/"
User=${user}
Type=simple
Restart=on-failure
RestartSec=10
StandardOutput=null
StandardError=syslog
[Install]
WantedBy=multi-user.target
SERV
echo_progress_done "Komga service installed"

# This checks if nginx is installed, if it is, then it will install nginx config for komga
if [[ -f /install/.nginx.lock ]]; then
    echo_progress_start "Installing nginx config"
    cat > /etc/nginx/apps/komga.conf <<- NGX
location /komga {
  include /etc/nginx/snippets/proxy.conf;
  proxy_pass        http://127.0.0.1:8080/komga;
}
NGX
# Reload nginx
systemctl reload nginx
echo_progress_done "Nginx config applied"
fi

echo_progress_start "Patching panel."
systemctl enable --now komga.service  >> $log 2>&1
#Install Swizzin Panel Profiles
curl -L https://raw.githubusercontent.com/selfhosters/unRAID-CA-templates/master/templates/img/komga.png -o "/opt/swizzin/static/img/apps/komga.png" >> $log 2>&1
if [[ -f /install/.panel.lock ]]; then
    cat << EOF >> /opt/swizzin/core/custom/profiles.py
class komga_meta:
    name = "komga"
    pretty_name = "Komga"
    baseurl = "/komga"
    systemd = "komga"
    img = "komga"
EOF
fi
touch /install/.komga.lock   >> $log 2>&1
echo_progress_done "Panel patched."
systemctl restart panel   >> $log 2>&1
echo_progress_done "Done."