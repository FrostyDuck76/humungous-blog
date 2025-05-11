#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] User ran /usr/sbin/custom-privileged-script.sh to run a custom privileged script as root" >> "/var/log/privileged_script_execution.log"

sleep 5

if [ -f "/home/privileged-script-manager/.aws/credentials" ]; then
    # Download the custom privileged script from GitHub and configure it
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/privileged-script.sh -o "/home/privileged-script-manager/privileged-script.sh"
    dos2unix "/home/privileged-script-manager/privileged-script.sh"
    chmod +x "/home/privileged-script-manager/privileged-script.sh"

    # Temporarily unlock the S3 encryption key for use with encrypting the downloaded privileged script before uploading to an S3 bucket
    chown privileged-script-manager:privileged-script-manager "/s3_encryption_key.bin"
    gpg --batch --symmetric --cipher-algo AES256 --output "/home/privileged-script-manager/privileged-script.sh.gpg" --passphrase-file "/s3_encryption_key.bin" "/home/privileged-script-manager/privileged-script.sh"
    chown privileged-script-manager:privileged-script-manager "/home/privileged-script-manager/privileged-script.sh.gpg"
    su - -c "/usr/local/bin/aws s3 cp /home/privileged-script-manager/privileged-script.sh.gpg s3://humungous-privileged-scripts/" privileged-script-manager
    rm "/home/privileged-script-manager/privileged-script.sh.gpg"
    chown root:root "/s3_encryption_key.bin"

    # Execute the custom privileged script as root
    "/home/privileged-script-manager/privileged-script.sh"

    # Delete the custom privileged script after executing it
    rm "/home/privileged-script-manager/privileged-script.sh"
else
    echo "Error: Could not find AWS credentials in /home/privileged-script-manager/.aws/credentials"
fi
