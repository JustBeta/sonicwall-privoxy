#!/bin/sh

apk add --no-cache privoxy 

echo "confdir /etc/privoxy" > /etc/privoxy/config
echo "" >> /etc/privoxy/config
echo "listen-address  0.0.0.0:8118" >> /etc/privoxy/config
echo "" >> /etc/privoxy/config
echo "debug   1    # Show each GET/POST/CONNECT request" >> /etc/privoxy/config
echo "debug   4096 # Startup banner and warnings" >> /etc/privoxy/config
