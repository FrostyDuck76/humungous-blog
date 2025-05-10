#!/bin/bash

TCPDUMP_CAPTURE_FILE=$(cat /active_tcpdump_capture_file.txt)

chown humungous:humungous "/home/humungous/.aws/credentials"
chmod 644 "/s3_encryption_key.bin"
gpg --batch --symmetric --cipher-algo AES256 --output "/home/humungous/$TCPDUMP_CAPTURE_FILE.gpg" --passphrase-file "/s3_encryption_key.bin" "/var/log/tcpdumpd/$TCPDUMP_CAPTURE_FILE"
chown humungous:humungous "/home/humungous/$TCPDUMP_CAPTURE_FILE.gpg"
su - -c "/usr/local/bin/aws s3 cp /home/humungous/$TCPDUMP_CAPTURE_FILE.gpg s3://humungous-tcpdump-captures/" humungous
rm "/home/humungous/$TCPDUMP_CAPTURE_FILE.gpg"
chmod 600 "/s3_encryption_key.bin"
chown root:root "/home/humungous/.aws/credentials"

rm "/active_tcpdump_capture_file.txt"
