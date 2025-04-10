#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] User ran /usr/sbin/renew-certificate.sh to try renewing a Let's Encrypt certificate" >> "/var/log/privileged_script_execution.log"

sleep 5
certbot renew