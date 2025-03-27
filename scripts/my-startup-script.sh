#!/bin/bash

# Wait 3 minutes
sleep 180
systemctl start telnet.socket
systemctl start stunnel.service

# Wait 5 minutes
sleep 300
systemctl start vsftpd.service
systemctl start nginx.service
systemctl start my-node-server.service