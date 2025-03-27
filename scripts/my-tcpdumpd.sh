#!/bin/bash

export TIME=$(printf '%(%Y_%m_%d_%H_%M_%S)T')
tcpdump --interface any -w "/var/log/tcpdumpd/capture_$TIME.pcap"