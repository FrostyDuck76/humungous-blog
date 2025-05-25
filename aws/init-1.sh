#!/bin/bash

# Disable the public SSH key specified when creating the droplet and uninstall the SSH daemon
mv "/root/.ssh/authorized_keys" "/root/authorized_ssh_key"
dnf remove openssh-server --assumeyes &>> /var/log/dnf_output.log

# Install the necessary packages
dnf install tcpdump --assumeyes &>> /var/log/dnf_output.log
dnf install dos2unix --assumeyes &>> /var/log/dnf_output.log
dnf install nodejs --assumeyes &>> /var/log/dnf_output.log
dnf install vsftpd --assumeyes &>> /var/log/dnf_output.log
dnf install telnet-server --assumeyes &>> /var/log/dnf_output.log
dnf install iptables --assumeyes &>> /var/log/dnf_output.log
dnf install openssl --assumeyes &>> /var/log/dnf_output.log
dnf install stunnel --assumeyes &>> /var/log/dnf_output.log
dnf install unzip --assumeyes &>> /var/log/dnf_output.log
dnf install jq --assumeyes &>> /var/log/dnf_output.log

# Install and set up the CloudWatch agent
curl -L https://s3.ap-southeast-2.amazonaws.com/amazoncloudwatch-agent-ap-southeast-2/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm -o "/root/amazon-cloudwatch-agent.rpm"
rpm -i "/root/amazon-cloudwatch-agent.rpm"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/amazon-cloudwatch-agent.json -o "/root/amazon-cloudwatch-agent.json"
mv "/root/amazon-cloudwatch-agent.json" "/opt/aws/amazon-cloudwatch-agent/etc/"
chown root:cwagent "/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
chmod 640 "/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
systemctl enable amazon-cloudwatch-agent.service
systemctl start amazon-cloudwatch-agent.service

# Manage some services
systemctl disable vsftpd.service
systemctl disable telnet.socket
systemctl disable stunnel.service
systemctl disable sshd.service
systemctl stop vsftpd.service
systemctl stop stunnel.service
systemctl stop telnet.socket
systemctl stop sshd.service

# Download scripts and services from pastebin.com
mkdir -p "/root/scripts/"
mkdir -p "/root/services/"

curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-restart-script.sh -o "/root/scripts/my-restart-script.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-shutdown-script.sh -o "/root/scripts/my-shutdown-script.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-startup-script.sh -o "/root/scripts/my-startup-script.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-tcpdumpd.sh -o "/root/scripts/my-tcpdumpd.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-tcpdumpd-killscript.sh -o "/root/scripts/my-tcpdumpd-killscript.sh"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/regenerate-internal-certificate.sh -o "/root/scripts/regenerate-internal-certificate.sh"

curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-restart-script.service -o "/root/services/my-restart-script.service"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-shutdown-script.service -o "/root/services/my-shutdown-script.service"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-startup-script.service -o "/root/services/my-startup-script.service"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/services/my-tcpdumpd.service -o "/root/services/my-tcpdumpd.service"

# Download configurations
mkdir -p "/root/configs/"
mkdir -p "/root/configs_old/"

curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/vsftpd.conf -o "/root/configs/vsftpd.conf"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/stunnel.conf -o "/root/configs/stunnel.conf"
curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/99-restricted-user -o "/root/configs/99-restricted-user"

# Convert line-encodings from CRLF to LF
dos2unix "/root/scripts/my-restart-script.sh"
dos2unix "/root/scripts/my-shutdown-script.sh"
dos2unix "/root/scripts/my-startup-script.sh"
dos2unix "/root/scripts/my-tcpdumpd.sh"
dos2unix "/root/scripts/my-tcpdumpd-killscript.sh"
dos2unix "/root/scripts/regenerate-internal-certificate.sh"
dos2unix "/root/services/my-restart-script.service"
dos2unix "/root/services/my-shutdown-script.service"
dos2unix "/root/services/my-startup-script.service"
dos2unix "/root/services/my-tcpdumpd.service"
dos2unix "/root/configs/vsftpd.conf"
dos2unix "/root/configs/stunnel.conf"
dos2unix "/root/configs/99-restricted-user"

# Move downloaded scripts to /usr/bin
mv "/root/scripts/my-restart-script.sh" "/usr/bin/"
mv "/root/scripts/my-shutdown-script.sh" "/usr/bin/"
mv "/root/scripts/my-startup-script.sh" "/usr/bin/"
mv "/root/scripts/my-tcpdumpd.sh" "/usr/bin/"
mv "/root/scripts/my-tcpdumpd-killscript.sh" "/usr/bin/"

# Move downloaded privileged scripts to /usr/sbin
mv "/root/scripts/regenerate-internal-certificate.sh" "/usr/sbin/"

# Restore security context of scripts
restorecon "/usr/bin/my-restart-script.sh"
restorecon "/usr/bin/my-shutdown-script.sh"
restorecon "/usr/bin/my-startup-script.sh"
restorecon "/usr/bin/my-tcpdumpd.sh"
restorecon "/usr/bin/my-tcpdumpd-killscript.sh"
restorecon "/usr/sbin/regenerate-internal-certificate.sh"

# Make all downloaded scripts executable
chmod +x "/usr/bin/my-restart-script.sh"
chmod +x "/usr/bin/my-shutdown-script.sh"
chmod +x "/usr/bin/my-startup-script.sh"
chmod +x "/usr/bin/my-tcpdumpd.sh"
chmod +x "/usr/bin/my-tcpdumpd-killscript.sh"
chmod +x "/usr/sbin/regenerate-internal-certificate.sh"

# Move downloaded services to /etc/systemd/system
mv "/root/services/my-restart-script.service" "/etc/systemd/system/"
mv "/root/services/my-shutdown-script.service" "/etc/systemd/system/"
mv "/root/services/my-startup-script.service" "/etc/systemd/system/"
mv "/root/services/my-tcpdumpd.service" "/etc/systemd/system/"
mkdir -p "/var/log/tcpdumpd/"

# Restore security context of services
restorecon "/etc/systemd/system/my-restart-script.service"
restorecon "/etc/systemd/system/my-shutdown-script.service"
restorecon "/etc/systemd/system/my-startup-script.service"
restorecon "/etc/systemd/system/my-tcpdumpd.service"

# Manage some services again
systemctl daemon-reload
systemctl enable my-startup-script.service
systemctl enable my-tcpdumpd.service

# Create RSA certificates for use by three different services
mkdir -p "/etc/ssl/private/"
mkdir -p "/etc/ssl/certs/"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/internal.key -out /etc/ssl/certs/internal.crt -subj "/O=Internal Services/OU=Infrastructure/CN=16.176.112.30" -addext "subjectAltName = IP:16.176.112.30"
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

# Create a directory to archive retired AWS credentials
mkdir "/root/retired_aws_credentials/"

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
mkdir "/home/humungous/tcpdumpd/"
chown root:root "/home/humungous/tcpdumpd/"
chmod 755 "/home/humungous/tcpdumpd/"
echo "/var/log/tcpdumpd    /home/humungous/tcpdumpd    none    bind    0    0" >> "/etc/fstab"

# Make the initial public SSH key available to the user
cp "/root/authorized_ssh_key" "/home/humungous/"
chown humungous:humungous "/home/humungous/authorized_ssh_key"
chmod 644 "/home/humungous/authorized_ssh_key"

# Set a password for the new user from a file
echo "humungous:$(cat /password.txt)" | chpasswd
rm "/password.txt"

# Apply configurations to existing services
if [ -f "/etc/vsftpd/vsftpd.conf" ]; then
    mv "/etc/vsftpd/vsftpd.conf" "/root/configs_old/"
fi
if [ -f "/etc/stunnel/stunnel.conf" ]; then
    mv "/etc/stunnel/stunnel.conf" "/root/configs_old/"
fi
mv "/root/configs/vsftpd.conf" "/etc/vsftpd/"
mv "/root/configs/stunnel.conf" "/etc/stunnel/"

# Apply pre-configured sudoers file that allows the user to run some commands as root
mv "/root/configs/99-restricted-user" "/etc/sudoers.d/"
chmod 440 "/etc/sudoers.d/99-restricted-user"
visudo --check "/etc/sudoers.d/99-restricted-user" > "/home/humungous/simple_visudo_check.txt"
chown humungous:humungous "/home/humungous/simple_visudo_check.txt"
chmod 644 "/home/humungous/simple_visudo_check.txt"

# Enable SELinux boolean to allow FTP full access
setsebool -P ftpd_full_access on

# Restore security context of configurations
restorecon "/etc/vsftpd/vsftpd.conf"
restorecon "/etc/stunnel/stunnel.conf"
restorecon "/etc/sudoers.d/99-restricted-user"

# Finalise the initialization
echo "All the steps are done, the server should work as expected" >> "/done.txt"
sleep 30
systemctl reboot
