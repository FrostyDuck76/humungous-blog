#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] User ran /usr/sbin/regenerate-internal-certificate.sh to schedule regenerating internal certificates on the next startup" >> "/var/log/privileged_script_execution.log"

if [ ! -f "/regenerate_internal_certificate.txt" ]; then
    touch "/regenerate_internal_certificate.txt"
    echo "System will regenerate an internal certificate on the next startup."
else
    echo "System has already been scheduled to regenerate an internal certificate on the next startup!"
fi