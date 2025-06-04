#!/bin/bash

# Clean up
rm "/home/humungous/.aws/config"
rm "/usr/bin/my-startup-script.sh"
rm "/usr/bin/my-tcpdumpd-s3-uploader.sh"
rm "/etc/ssl/private/internal.key"
rm "/etc/ssl/certs/internal.crt"

# Install the necessary packages
dnf install nginx --assumeyes &>> /var/log/dnf_output.log
dnf install openssh-server --assumeyes &>> /var/log/dnf_output.log

# Set up certbot and its DNS plugins
dnf install epel-release --assumeyes &>> /var/log/dnf_output.log
/usr/bin/crb enable
dnf install certbot --assumeyes &>> /var/log/dnf_output.log
dnf install python3-certbot-dns-digitalocean --assumeyes &>> /var/log/dnf_output.log
dnf install python3-certbot-dns-cloudflare --assumeyes &>> /var/log/dnf_output.log
dnf install python3-certbot-dns-route53 --assumeyes &>> /var/log/dnf_output.log

# Manage some services
systemctl disable nginx.service
systemctl stop nginx.service

# Download scripts and services from pastebin.com
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-startup-script.sh -o "/root/scripts/my-startup-script.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-tcpdumpd-s3-uploader.sh -o "/root/scripts/my-tcpdumpd-s3-uploader.sh"
# DEAL WITH THEM EXTRAS
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/generate-certificate.sh -o "/root/scripts/generate-certificate.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/renew-certificate.sh -o "/root/scripts/renew-certificate.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/renew-certificate-dry-run.sh -o "/root/scripts/renew-certificate-dry-run.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/check-certificate-expiry.sh -o "/root/scripts/check-certificate-expiry.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/change-api-token.sh -o "/root/scripts/change-api-token.sh"

# Download configurations
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/nginx.conf -o "/root/configs/nginx.conf"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/aws-config -o "/root/configs/aws-config"

# Convert line-encodings from CRLF to LF
dos2unix "/root/scripts/my-startup-script.sh"
dos2unix "/root/scripts/my-tcpdumpd-s3-uploader.sh"
dos2unix "/root/scripts/generate-certificate.sh"
dos2unix "/root/scripts/renew-certificate.sh"
dos2unix "/root/scripts/renew-certificate-dry-run.sh"
dos2unix "/root/scripts/check-certificate-expiry.sh"
dos2unix "/root/scripts/change-api-token.sh"
dos2unix "/root/configs/nginx.conf"
dos2unix "/root/configs/aws-config"

# Move downloaded scripts to /usr/bin
mv "/root/scripts/my-startup-script.sh" "/usr/bin/"
mv "/root/scripts/my-tcpdumpd-s3-uploader.sh" "/usr/bin"

# Move downloaded privileged scripts to /usr/sbin
mv "/root/scripts/generate-certificate.sh" "/usr/sbin/"
mv "/root/scripts/renew-certificate.sh" "/usr/sbin/"
mv "/root/scripts/renew-certificate-dry-run.sh" "/usr/sbin/"
mv "/root/scripts/check-certificate-expiry.sh" "/usr/sbin/"
mv "/root/scripts/change-api-token.sh" "/usr/sbin/"

# Restore security context of scripts
restorecon "/usr/bin/my-startup-script.sh"
restorecon "/usr/bin/my-tcpdumpd-s3-uploader.sh"
restorecon "/usr/sbin/generate-certificate.sh"
restorecon "/usr/sbin/renew-certificate.sh"
restorecon "/usr/sbin/renew-certificate-dry-run.sh"
restorecon "/usr/sbin/check-certificate-expiry.sh"
restorecon "/usr/sbin/change-api-token.sh"

# Make all downloaded scripts executable
chmod +x "/usr/bin/my-startup-script.sh"
chmod +x "/usr/bin/my-tcpdumpd-s3-uploader.sh"
chmod +x "/usr/sbin/generate-certificate.sh"
chmod +x "/usr/sbin/renew-certificate.sh"
chmod +x "/usr/sbin/renew-certificate-dry-run.sh"
chmod +x "/usr/sbin/check-certificate-expiry.sh"
chmod +x "/usr/sbin/change-api-token.sh"

# Manage some services again
systemctl daemon-reload

# Create RSA certificates for use by three different services
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/internal.key -out /etc/ssl/certs/internal.crt -subj "/O=Internal Services/OU=Infrastructure/CN=18.134.32.42" -addext "subjectAltName = IP:18.134.32.42"

# Change permissions of the 'internal' certificate to be readable only by root
chmod 600 "/etc/ssl/private/internal.key"
chmod 644 "/etc/ssl/certs/internal.crt"

# Restore security context of certificates
restorecon "/etc/ssl/private/internal.key"
restorecon "/etc/ssl/certs/internal.crt"

# Non-root user management
mkdir -p "/var/www/html/"
chown humungous:humungous --recursive "/var/www/html/"
mkdir "/home/humungous/html/"
chown humungous:humungous "/home/humungous/html/"
echo "/var/www/html    /home/humungous/html    none    bind    0    0" >> "/etc/fstab"

# Apply configurations to existing services
if [ -f "/etc/nginx/nginx.conf" ]; then
    mv "/etc/nginx/nginx.conf" "/root/configs_old/"
fi
mv "/root/configs/nginx.conf" "/etc/nginx/"

# Apply configurations to AWS CLI
mv "/root/configs/aws-config" "/home/humungous/.aws/config"
chown root:root "/home/humungous/.aws/config"
chmod 644 "/home/humungous/.aws/config"

# Restore security context of configurations
restorecon "/etc/nginx/nginx.conf"

# Finalise the initialization
echo "All the steps are done, the server should work as expected" >> "/done.txt"
