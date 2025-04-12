#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] User ran /usr/sbin/generate-certificate.sh to try generating an LE certificate" >> "/var/log/privileged_script_execution.log"

sleep 5

if [ -f "/etc/letsencrypt/digitalocean.ini" ]; then
    # Use the DigitalOcean API for DNS validation
    certbot certonly --dns-digitalocean --dns-digitalocean-credentials /etc/letsencrypt/digitalocean.ini -d humungous.blog -d www.humungous.blog
elif [ -f "/etc/letsencrypt/cloudflare.ini" ]; then
    # Use the Cloudflare API for DNS validation
    certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini -d humungous.blog -d www.humungous.blog
elif [ -f "/etc/letsencrypt/route53.ini" ]; then
    # Use the Amazon Route 53 API for DNS validation
    certbot certonly --dns-route53 --dns-route53-credentials /etc/letsencrypt/route53.ini -d humungous.blog -d www.humungous.blog
else
    # Fallback to manual DNS validation if any of these options don't work
    certbot certonly --manual --preferred-challenges dns -d humungous.blog -d www.humungous.blog
fi
