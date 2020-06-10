#!/bin/bash
/etc/init.d/ssh start &
nohup /analytics.sh > /dev/null 2>&1 &
supervisor -w /node/ /node/server.js