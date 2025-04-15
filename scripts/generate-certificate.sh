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

# Allow the group read-only access to Let's Encrypt certificates stored in /etc/letsencrypt/live
if [ -d "/etc/letsencrypt/live/" ]; then
    chgrp 'ssl-cert' --recursive "/etc/letsencrypt/live/"
    chmod 750 "/etc/letsencrypt/live/"
    chmod 750 "/etc/letsencrypt/live/humungous.blog/"
    chmod 640 "/etc/letsencrypt/live/humungous.blog/cert.pem"
    chmod 640 "/etc/letsencrypt/live/humungous.blog/chain.pem"
    chmod 640 "/etc/letsencrypt/live/humungous.blog/fullchain.pem"
    chmod 640 "/etc/letsencrypt/live/humungous.blog/privkey.pem"
    chmod 750 "/etc/letsencrypt/live/www.humungous.blog/"
    chmod 640 "/etc/letsencrypt/live/www.humungous.blog/cert.pem"
    chmod 640 "/etc/letsencrypt/live/www.humungous.blog/chain.pem"
    chmod 640 "/etc/letsencrypt/live/www.humungous.blog/fullchain.pem"
    chmod 640 "/etc/letsencrypt/live/www.humungous.blog/privkey.pem"
fi

# Allow the group read-only access to Let's Encrypt certificates stored in /etc/letsencrypt/archive
if [ -d "/etc/letsencrypt/archive/" ]; then
    chgrp 'ssl-cert' --recursive "/etc/letsencrypt/archive/"
    chmod 750 "/etc/letsencrypt/archive/"
    chmod 750 "/etc/letsencrypt/archive/humungous.blog/"
    chmod 640 "/etc/letsencrypt/archive/humungous.blog/cert.pem"
    chmod 640 "/etc/letsencrypt/archive/humungous.blog/chain.pem"
    chmod 640 "/etc/letsencrypt/archive/humungous.blog/fullchain.pem"
    chmod 640 "/etc/letsencrypt/archive/humungous.blog/privkey.pem"
    chmod 750 "/etc/letsencrypt/archive/www.humungous.blog/"
    chmod 640 "/etc/letsencrypt/archive/www.humungous.blog/cert.pem"
    chmod 640 "/etc/letsencrypt/archive/www.humungous.blog/chain.pem"
    chmod 640 "/etc/letsencrypt/archive/www.humungous.blog/fullchain.pem"
    chmod 640 "/etc/letsencrypt/archive/www.humungous.blog/privkey.pem"
fi
