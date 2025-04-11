#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] User ran /usr/sbin/check-certificate-expiry.sh to check the expiry date of a Let's Encrypt certificate" >> "/var/log/privileged_script_execution.log"

certbot certificates