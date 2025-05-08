#!/bin/bash

TCPDUMP_PID=$(ps -e | pgrep tcpdump)
kill -2 $TCPDUMP_PID
