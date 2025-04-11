#!/bin/bash

# If the system is scheduled to regenerate an internal certificate, do it now
if [ -f "/regenerate_internal_certificate.txt" ]; then
    TIME=$(printf '%(%Y_%m_%d_%H_%M_%S)T')
    mkdir "/root/retired_certificates/$TIME/"
    mv "/etc/ssl/private/internal.key" "/root/retired_certificates/$TIME/"
    mv "/etc/ssl/certs/internal.crt" "/root/retired_certificates/$TIME/"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/internal.key -out /etc/ssl/certs/internal.crt -subj "/O=Internal Services/OU=Infrastructure/CN=159.203.54.90" -addext "subjectAltName = IP:159.203.54.90"
    chmod 600 "/etc/ssl/private/internal.key"
    chmod 644 "/etc/ssl/certs/internal.crt"
    restorecon "/etc/ssl/private/internal.key"
    restorecon "/etc/ssl/certs/internal.crt"
    rm "/regenerate_internal_certificate.txt"
fi

# Wait 3 minutes
sleep 180
systemctl start telnet.socket
systemctl start stunnel.service

# Wait 5 minutes
sleep 300
systemctl start vsftpd.service
systemctl start nginx.service
systemctl start my-node-server.service
