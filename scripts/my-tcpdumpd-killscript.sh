#!/bin/bash

# Locate and kill a running tcpdump process
export TCPDUMP_PID=$(ps -e | pgrep tcpdump)
kill -2 $TCPDUMP_PID

# Temporarily unlock the AWS credentials from the user's home directory before uploading the most recent tcpdump capture file to an S3 bucket
chown humungous:humungous "/home/humungous/.aws/credentials"
su - -c "aws s3 cp /var/log/tcpdumpd/$(cat /active_tcpdump_capture_file.txt) s3://humungous-tcpdump-captures/" humungous
chown root:root "/home/humungous/.aws/credentials"

rm "/active_tcpdump_capture_file.txt"
