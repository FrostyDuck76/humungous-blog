#!/bin/bash

export TIME=$(printf '%(%Y_%m_%d_%H_%M_%S)T')
node --tls-keylog="/home/humungous/express-app/tls-keylogs/tls_key_$TIME.log" "/home/humungous/express-app/server.js"