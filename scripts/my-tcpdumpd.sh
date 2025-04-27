#!/bin/bash

export TIME=$(printf '%(%Y_%m_%d_%H_%M_%S)T')
echo "capture_$TIME.pcap" > "/active_tcpdump_capture_file.txt"
tcpdump --interface any -w "/var/log/tcpdumpd/capture_$TIME.pcap"
