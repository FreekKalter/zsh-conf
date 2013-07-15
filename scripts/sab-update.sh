#!/bin/bash
set -e
set -o pipefail

stop sabnzbd
sleep 20

cd /tmp/
wget http://sourceforge.net/projects/sabnzbdplus/files/latest/download\?source\=dlp -O sabnzbd.tar.gz

FOLDER=`tar -xvzf sabnzbd.tar.gz | sed 's/\/.*//' | tail -n1`
rm sabnzbd.tar.gz
mv $FOLDER /usr/local/bin

cd /usr/local/bin
chown fkalter:fkalter $FOLDER
rm SABnzbd
ln -s /usr/local/bin/$FOLDER /usr/local/bin/SABnzbd

start sabnzbd
