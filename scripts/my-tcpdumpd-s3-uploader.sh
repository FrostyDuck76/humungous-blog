#!/bin/bash

TCPDUMP_CAPTURE_FILE=$(cat /active_tcpdump_capture_file.txt)

chown humungous:humungous "/home/humungous/.aws/credentials"
su - -c "/usr/local/bin/aws s3 cp /var/log/tcpdumpd/$TCPDUMP_CAPTURE_FILE s3://humungous-my-tcpdump-captures/web-app/i-061e86e73380cb16e/" humungous
chown root:root "/home/humungous/.aws/credentials"

rm "/active_tcpdump_capture_file.txt"
