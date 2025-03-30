#!/bin/bash

# Install the necessary packages
dnf install tcpdump --assumeyes &>> /var/log/dnf_output.log
dnf install dos2unix --assumeyes &>> /var/log/dnf_output.log
dnf install nodejs --assumeyes &>> /var/log/dnf_output.log
dnf install vsftpd --assumeyes &>> /var/log/dnf_output.log
dnf install nginx --assumeyes &>> /var/log/dnf_output.log
dnf install telnet-server --assumeyes &>> /var/log/dnf_output.log
dnf install iptables --assumeyes &>> /var/log/dnf_output.log
dnf install openssl --assumeyes &>> /var/log/dnf_output.log
dnf install stunnel --assumeyes &>> /var/log/dnf_output.log
dnf install certbot --assumeyes &>> /var/log/dnf_output.log

# Manage some services
systemctl disable vsftpd.service
systemctl disable nginx.service
systemctl disable telnet.socket
systemctl disable stunnel.service
systemctl disable sshd.service
systemctl stop vsftpd.service
systemctl stop nginx.service
systemctl stop stunnel.service
systemctl stop telnet.socket

# Download scripts and services from pastebin.com
mkdir -p "/root/scripts/"
mkdir -p "/root/services/"

curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-restart-script.sh -o "/root/scripts/my-restart-script.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-shutdown-script.sh -o "/root/scripts/my-shutdown-script.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-startup-script.sh -o "/root/scripts/my-startup-script.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-node-server.sh -o "/root/scripts/my-node-server.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-tcpdumpd-killscript.sh -o "/root/scripts/my-tcpdumpd-killscript.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-tcpdumpd.sh -o "/root/scripts/my-tcpdumpd.sh"

curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-restart-script.service -o "/root/services/my-restart-script.service"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-shutdown-script.service -o "/root/services/my-shutdown-script.service"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-startup-script.service -o "/root/services/my-startup-script.service"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-node-server.service -o "/root/services/my-node-server.service"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-tcpdumpd.service -o "/root/services/my-tcpdumpd.service"

# Download configurations
mkdir -p "/root/configs/"
mkdir -p "/root/configs_old/"

curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/vsftpd.conf -o "/root/configs/vsftpd.conf"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/nginx.conf -o "/root/configs/nginx.conf"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/stunnel.conf -o "/root/configs/stunnel.conf"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/server.js -o "/root/configs/server.js"

# Convert line-encodings from CRLF to LF
dos2unix "/root/scripts/my-restart-script.sh"
dos2unix "/root/scripts/my-shutdown-script.sh"
dos2unix "/root/scripts/my-startup-script.sh"
dos2unix "/root/scripts/my-node-server.sh"
dos2unix "/root/scripts/my-tcpdumpd-killscript.sh"
dos2unix "/root/scripts/my-tcpdumpd.sh"
dos2unix "/root/services/my-restart-script.service"
dos2unix "/root/services/my-shutdown-script.service"
dos2unix "/root/services/my-startup-script.service"
dos2unix "/root/services/my-node-server.service"
dos2unix "/root/services/my-tcpdumpd.service"
dos2unix "/root/configs/vsftpd.conf"
dos2unix "/root/configs/nginx.conf"
dos2unix "/root/configs/stunnel.conf"
dos2unix "/root/configs/server.js"

# Move downloaded scripts to /usr/bin
mv "/root/scripts/my-restart-script.sh" "/usr/bin/"
mv "/root/scripts/my-shutdown-script.sh" "/usr/bin/"
mv "/root/scripts/my-startup-script.sh" "/usr/bin/"
mv "/root/scripts/my-node-server.sh" "/usr/bin/"
mv "/root/scripts/my-tcpdumpd-killscript.sh" "/usr/bin/"
mv "/root/scripts/my-tcpdumpd.sh" "/usr/bin/"

# Restore security context of scripts
restorecon "/usr/bin/my-restart-script.sh"
restorecon "/usr/bin/my-shutdown-script.sh"
restorecon "/usr/bin/my-startup-script.sh"
restorecon "/usr/bin/my-node-server.sh"
restorecon "/usr/bin/my-tcpdumpd-killscript.sh"
restorecon "/usr/bin/my-tcpdumpd.sh"

# Make all downloaded scripts executable
chmod +x "/usr/bin/my-restart-script.sh"
chmod +x "/usr/bin/my-shutdown-script.sh"
chmod +x "/usr/bin/my-startup-script.sh"
chmod +x "/usr/bin/my-node-server.sh"
chmod 755 "/usr/bin/my-node-server.sh"
chmod +x "/usr/bin/my-tcpdumpd-killscript.sh"
chmod +x "/usr/bin/my-tcpdumpd.sh"

# Move downloaded services to /etc/systemd/system
mv "/root/services/my-restart-script.service" "/etc/systemd/system/"
mv "/root/services/my-shutdown-script.service" "/etc/systemd/system/"
mv "/root/services/my-startup-script.service" "/etc/systemd/system/"
mv "/root/services/my-node-server.service" "/etc/systemd/system/"
mv "/root/services/my-tcpdumpd.service" "/etc/systemd/system/"
mkdir -p "/var/log/tcpdumpd/"

# Restore security context of services
restorecon "/etc/systemd/system/my-restart-script.service"
restorecon "/etc/systemd/system/my-shutdown-script.service"
restorecon "/etc/systemd/system/my-startup-script.service"
restorecon "/etc/systemd/system/my-node-server.service"
restorecon "/etc/systemd/system/my-tcpdumpd.service"

# Manage some services again
systemctl daemon-reload
systemctl enable my-startup-script.service
systemctl enable my-tcpdumpd.service

# Create RSA certificates for use by three different services
mkdir -p "/etc/ssl/private/"
mkdir -p "/etc/ssl/certs/"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/unified.key -out /etc/ssl/certs/unified.crt -subj "/C=AU/ST=Queensland/L=Brisbane/O=Humungous Blogs/CN=humungous.blog/emailAddress=admin@humungous.blog"

# Change permissions of certificates to be readable by anyone other than root
chmod 755 "/etc/ssl/private/unified.key"
chmod 755 "/etc/ssl/certs/unified.crt"

# Restore security context of certificates
restorecon "/etc/ssl/private/unified.key"
restorecon "/etc/ssl/certs/unified.crt"

# Configure firewall rules
firewall-cmd --permanent --add-port=23/tcp
firewall-cmd --permanent --add-port=23/udp
firewall-cmd --permanent --add-port=2323/tcp
firewall-cmd --permanent --add-port=2323/udp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=80/udp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=443/udp
firewall-cmd --reload

# Non-root user management
useradd humungous
usermod humungous -aG 'wheel'
mkdir -p "/var/www/html/"
chown humungous:humungous --recursive "/var/www/html/"
mkdir "/home/humungous/html/"
chown humungous:humungous "/home/humungous/html/"
echo "/var/www/html    /home/humungous/html    none    bind    0    0" >> "/etc/fstab"

# Set a password for the new user from a file
echo "humungous:$(cat /password.txt)" | sudo chpasswd
rm "/password.txt"

# Apply configurations to existing services
if [ -f "/etc/vsftpd/vsftpd.conf" ]; then
    mv "/etc/vsftpd/vsftpd.conf" "/root/configs_old/"
fi
if [ -f "/etc/nginx/nginx.conf" ]; then
    mv "/etc/nginx/nginx.conf" "/root/configs_old/"
fi
if [ -f "/etc/stunnel/stunnel.conf" ]; then
    mv "/etc/stunnel/stunnel.conf" "/root/configs_old/"
fi
mv "/root/configs/vsftpd.conf" "/etc/vsftpd/"
mv "/root/configs/nginx.conf" "/etc/nginx/"
mv "/root/configs/stunnel.conf" "/etc/stunnel/"

# Enable SELinux boolean to allow FTP full access
setsebool -P ftpd_full_access on

# Set up the express app to host a web server using Node.js
mkdir "/home/humungous/express-app/"
mkdir "/home/humungous/express-app/tls-keylogs/"
chown humungous:humungous --recursive "/home/humungous/express-app/"
chmod --recursive 700 "/home/humungous/express-app/tls-keylogs/"
su - -c "cd /home/humungous/express-app/ && npm init -y" humungous
su - -c "cd /home/humungous/express-app/ && npm install express" humungous
setcap 'cap_net_bind_service=+ep' $(readlink -f /usr/bin/node)
mv "/root/configs/server.js" "/home/humungous/express-app/"
chown humungous:humungous "/home/humungous/express-app/server.js"

# Restore security context of configurations
restorecon "/etc/vsftpd/vsftpd.conf"
restorecon "/etc/nginx/nginx.conf"
restorecon "/etc/stunnel/stunnel.conf"
restorecon "/home/humungous/express-app/server.js"

# Finalise the initialization
echo "All the steps are done, the server should work as expected" >> "/done.txt"
sleep 30
systemctl poweroff
