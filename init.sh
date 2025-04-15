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

# Set up certbot and its DNS plugins
dnf install epel-release --assumeyes &>> /var/log/dnf_output.log
/usr/bin/crb enable
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
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/generate-certificate.sh -o "/root/scripts/generate-certificate.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/renew-certificate.sh -o "/root/scripts/renew-certificate.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/renew-certificate-dry-run.sh -o "/root/scripts/renew-certificate-dry-run.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/check-certificate-expiry.sh -o "/root/scripts/check-certificate-expiry.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/regenerate-internal-certificate.sh -o "/root/scripts/regenerate-internal-certificate.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/change-api-token.sh -o "/root/scripts/change-api-token.sh"

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
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/99-restricted-user -o "/root/configs/99-restricted-user"

# Convert line-encodings from CRLF to LF
dos2unix "/root/scripts/my-restart-script.sh"
dos2unix "/root/scripts/my-shutdown-script.sh"
dos2unix "/root/scripts/my-startup-script.sh"
dos2unix "/root/scripts/my-node-server.sh"
dos2unix "/root/scripts/my-tcpdumpd-killscript.sh"
dos2unix "/root/scripts/my-tcpdumpd.sh"
dos2unix "/root/scripts/generate-certificate.sh"
dos2unix "/root/scripts/renew-certificate.sh"
dos2unix "/root/scripts/renew-certificate-dry-run.sh"
dos2unix "/root/scripts/check-certificate-expiry.sh"
dos2unix "/root/scripts/regenerate-internal-certificate.sh"
dos2unix "/root/scripts/change-api-token.sh"
dos2unix "/root/services/my-restart-script.service"
dos2unix "/root/services/my-shutdown-script.service"
dos2unix "/root/services/my-startup-script.service"
dos2unix "/root/services/my-node-server.service"
dos2unix "/root/services/my-tcpdumpd.service"
dos2unix "/root/configs/vsftpd.conf"
dos2unix "/root/configs/nginx.conf"
dos2unix "/root/configs/stunnel.conf"
dos2unix "/root/configs/server.js"
dos2unix "/root/configs/99-restricted-user"

# Move downloaded scripts to /usr/bin
mv "/root/scripts/my-restart-script.sh" "/usr/bin/"
mv "/root/scripts/my-shutdown-script.sh" "/usr/bin/"
mv "/root/scripts/my-startup-script.sh" "/usr/bin/"
mv "/root/scripts/my-node-server.sh" "/usr/bin/"
mv "/root/scripts/my-tcpdumpd-killscript.sh" "/usr/bin/"
mv "/root/scripts/my-tcpdumpd.sh" "/usr/bin/"

# Move downloaded privileged scripts to /usr/sbin
mv "/root/scripts/generate-certificate.sh" "/usr/sbin/"
mv "/root/scripts/renew-certificate.sh" "/usr/sbin/"
mv "/root/scripts/renew-certificate-dry-run.sh" "/usr/sbin/"
mv "/root/scripts/check-certificate-expiry.sh" "/usr/sbin/"
mv "/root/scripts/regenerate-internal-certificate.sh" "/usr/sbin/"
mv "/root/scripts/change-api-token.sh" "/usr/sbin/"

# Restore security context of scripts
restorecon "/usr/bin/my-restart-script.sh"
restorecon "/usr/bin/my-shutdown-script.sh"
restorecon "/usr/bin/my-startup-script.sh"
restorecon "/usr/bin/my-node-server.sh"
restorecon "/usr/bin/my-tcpdumpd-killscript.sh"
restorecon "/usr/bin/my-tcpdumpd.sh"
restorecon "/usr/sbin/generate-certificate.sh"
restorecon "/usr/sbin/renew-certificate.sh"
restorecon "/usr/sbin/renew-certificate-dry-run.sh"
restorecon "/usr/sbin/check-certificate-expiry.sh"
restorecon "/usr/sbin/regenerate-internal-certificate.sh"
restorecon "/usr/sbin/change-api-token.sh"

# Make all downloaded scripts executable
chmod +x "/usr/bin/my-restart-script.sh"
chmod +x "/usr/bin/my-shutdown-script.sh"
chmod +x "/usr/bin/my-startup-script.sh"
chmod +x "/usr/bin/my-node-server.sh"
chmod 755 "/usr/bin/my-node-server.sh"
chmod +x "/usr/bin/my-tcpdumpd-killscript.sh"
chmod +x "/usr/bin/my-tcpdumpd.sh"
chmod +x "/usr/sbin/generate-certificate.sh"
chmod +x "/usr/sbin/renew-certificate.sh"
chmod +x "/usr/sbin/renew-certificate-dry-run.sh"
chmod +x "/usr/sbin/check-certificate-expiry.sh"
chmod +x "/usr/sbin/regenerate-internal-certificate.sh"
chmod +x "/usr/sbin/change-api-token.sh"

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
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/internal.key -out /etc/ssl/certs/internal.crt -subj "/O=Internal Services/OU=Infrastructure/CN=159.203.54.90" -addext "subjectAltName = IP:159.203.54.90"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/unified.key -out /etc/ssl/certs/unified.crt -subj "/C=AU/ST=Queensland/L=Brisbane/O=Humungous Blogs/CN=humungous.blog/emailAddress=admin@humungous.blog" -addext "subjectAltName = DNS:humungous.blog,DNS:www.humungous.blog"

# Change permissions of the 'unified' certificate to be readable by anyone other than root
chmod 644 "/etc/ssl/private/unified.key"
chmod 644 "/etc/ssl/certs/unified.crt"

# Change permissions of the 'internal' certificate to be readable only by root
chmod 600 "/etc/ssl/private/internal.key"
chmod 644 "/etc/ssl/certs/internal.crt"

# Restore security context of certificates
restorecon "/etc/ssl/private/unified.key"
restorecon "/etc/ssl/certs/unified.crt"
restorecon "/etc/ssl/private/internal.key"
restorecon "/etc/ssl/certs/internal.crt"

# Create a directory to archive retired internal certificates when the user schedules regenerating an internal certificate
mkdir "/root/retired_certificates/"

# Create a directory to archive obsolete or compromised tokens when the user changes the API token for a DNS service
mkdir "/root/retired_tokens/"

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
mkdir -p "/var/www/html/"
chown humungous:humungous --recursive "/var/www/html/"
mkdir "/home/humungous/html/"
mkdir "/home/humungous/tcpdumpd/"
chown humungous:humungous "/home/humungous/html/"
chown root:root "/home/humungous/tcpdumpd/"
chmod 755 "/home/humungous/tcpdumpd/"
echo "/var/www/html    /home/humungous/html    none    bind    0    0" >> "/etc/fstab"
echo "/var/log/tcpdumpd    /home/humungous/tcpdumpd    none    bind    0    0" >> "/etc/fstab"

# Set up a group that allows read-only access to Let's Encrypt certificates
groupadd 'ssl-cert'
usermod humungous -aG 'ssl-cert'

# Set a password for the new user from a file
echo "humungous:$(cat /password.txt)" | chpasswd
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

# Apply pre-configured sudoers file that allows the user to run some commands as root
mv "/root/configs/99-restricted-user" "/etc/sudoers.d/"
chmod 440 "/etc/sudoers.d/99-restricted-user"
visudo --check "/etc/sudoers.d/99-restricted-user" > "/home/humungous/simple_visudo_check.txt"
chown humungous:humungous "/home/humungous/simple_visudo_check.txt"
chmod 644 "/home/humungous/simple_visudo_check.txt"

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
restorecon "/etc/sudoers.d/99-restricted-user"

# Enable debugging
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/enable-debugging.sh -o "/root/enable-debugging.sh"
dos2unix "/root/enable-debugging.sh"
chmod +x "/root/enable-debugging.sh"
restorecon "/root/enable-debugging.sh"
"/root/enable-debugging.sh"

# Finalise the initialization
echo "All the steps are done, the server should work as expected" >> "/done.txt"
sleep 30
systemctl poweroff
