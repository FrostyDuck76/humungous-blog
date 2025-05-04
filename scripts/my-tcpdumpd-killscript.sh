#!/bin/bash

# Locate and kill a running tcpdump process
export TCPDUMP_PID=$(ps -e | pgrep tcpdump)
kill -2 $TCPDUMP_PID

# Temporarily unlock the AWS credentials from the user's home directory before uploading the most recent tcpdump capture file to an S3 bucket
chown humungous:humungous "/home/humungous/.aws/credentials"
chmod 644 "/s3_encryption_key.bin"
gpg --batch --symmetric --cipher-algo AES256 --output "/home/humungous/$(cat /active_tcpdump_capture_file.txt).gpg" --passphrase-file "/s3_encryption_key.bin" "/var/log/tcpdumpd/$(cat /active_tcpdump_capture_file.txt)"
chown humungous:humungous "/home/humungous/$(cat /active_tcpdump_capture_file.txt).gpg"
su - -c "/usr/local/bin/aws s3 cp /home/humungous/$(cat /active_tcpdump_capture_file.txt).gpg s3://humungous-tcpdump-captures/" humungous
rm "/home/humungous/$(cat /active_tcpdump_capture_file.txt).gpg"
chmod 600 "/s3_encryption_key.bin"
chown root:root "/home/humungous/.aws/credentials"

rm "/active_tcpdump_capture_file.txt"
