#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] User ran /usr/sbin/change-api-token.sh to change the API token for a DNS service" >> "/var/log/privileged_script_execution.log"

TIME=$(printf '%(%Y_%m_%d_%H_%M_%S)T')

if [ -f "/home/humungous/digitalocean.ini" ]; then
    if [ -f "/etc/letsencrypt/digitalocean.ini" ]; then
        # If the directory for the specific time doesn't already exist, create one
        if [ ! -d "/root/retired_tokens/$TIME/" ]; then
            mkdir "/root/retired_tokens/$TIME/"
        fi
        # Move the current API token to the new directory
        mv "/etc/letsencrypt/digitalocean.ini" "/root/retired_tokens/$TIME/"
    fi
    # Lock down the API token from the user directory and move it to /etc/letsencrypt
    chown root:root "/home/humungous/digitalocean.ini"
    chmod 600 "/home/humungous/digitalocean.ini"
    mv "/home/humungous/digitalocean.ini" "/etc/letsencrypt/"
fi
if [ -f "/home/humungous/cloudflare.ini" ]; then
    if [ -f "/etc/letsencrypt/cloudflare.ini" ]; then
        # If the directory for the specific time doesn't already exist, create one
        if [ ! -d "/root/retired_tokens/$TIME/" ]; then
            mkdir "/root/retired_tokens/$TIME/"
        fi
        # Move the current API token to the new directory
        mv "/etc/letsencrypt/cloudflare.ini" "/root/retired_tokens/$TIME/"
    fi
    # Lock down the API token from the user directory and move it to /etc/letsencrypt
    chown root:root "/home/humungous/cloudflare.ini"
    chmod 600 "/home/humungous/cloudflare.ini"
    mv "/home/humungous/cloudflare.ini" "/etc/letsencrypt/"
fi
if [ -f "/home/humungous/route53.ini" ]; then
    if [ -f "/etc/letsencrypt/route53.ini" ]; then
        # If the directory for the specific time doesn't already exist, create one
        if [ ! -d "/root/retired_tokens/$TIME/" ]; then
            mkdir "/root/retired_tokens/$TIME/"
        fi
        # Move the current API token to the new directory
        mv "/etc/letsencrypt/route53.ini" "/root/retired_tokens/$TIME/"
    fi
    # Lock down the API token from the user directory and move it to /etc/letsencrypt
    chown root:root "/home/humungous/route53.ini"
    chmod 600 "/home/humungous/route53.ini"
    mv "/home/humungous/route53.ini" "/etc/letsencrypt/"
fi