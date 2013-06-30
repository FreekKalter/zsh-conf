#!/bin/bash
sudo truecrypt --auto-mount=favorites --keyfiles=/mnt/secret/down_secret
cp -H ~/scripts/gtk-bookmarks ~/.gtk-bookmarks
sudo start sabnzbd
