#!/bin/bash
sudo truecrypt --auto-mount=favorites --keyfiles=/mnt/secret/down_secret
cp -H ~/scripts/gtk-bookmarks ~/.gtk-bookmarks
sudo start sabnzbd

# Build Go from tip every 5 days
# (not a cron job because it needs an attached terminal)
cd ~/go/src
if [ $(( `date +%-d` % 5 )) -eq 0 ]; then
    hg sync
    ./all.bash
    goxc -t
else
    echo "Building go not needed today, `date +%-d`"
fi
