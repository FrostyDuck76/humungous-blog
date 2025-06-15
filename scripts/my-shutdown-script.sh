#!/bin/bash

# Wait 2 and a half minute
sleep 150
systemctl stop my-node-server.service
systemctl stop nginx.service
systemctl stop vsftpd.service
killall vsftpd

# Wait 2 and a half minute
sleep 150
systemctl stop sshd.service
systemctl stop stunnel.service
systemctl stop telnet.socket
killall stunnel
killall in.telnetd

# Stop the CloudWatch agent
systemctl stop amazon-cloudwatch-agent.service

# Wait 3 minutes
sleep 180
systemctl stop my-tcpdumpd.service

# Wait 2 minutes
sleep 120
systemctl poweroff
