#!/bin/sh

apk --no-cache add ppp openssl

# wget https://github.com/abrasive/nxBender/archive/refs/heads/master.zip -O /tmp/nxBender.zip
wget https://github.com/JustBeta/nxBender/archive/refs/heads/master.zip -O /tmp/nxBender.zip
unzip -o /tmp/nxBender.zip -d /
cd /nxBender-master
pip3 install .
pip3 install -r requirements.txt
cd /
rm  /tmp/nxBender.zip
rm -r /nxBender-master
