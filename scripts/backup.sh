#!/bin/bash

/home/fkalter/scripts/tarsnap-go -c --configfile /home/fkalter/.tarsnaprc --aggressive-networking --print-stats -X /home/fkalter/.tarsnap-home-exclude -f home /home/fkalter --nr-backups 3
/home/fkalter/scripts/tarsnap-go -c --configfile /home/fkalter/.tarsnaprc --aggressive-networking --print-stats -X /home/fkalter/.tarsnap-root-exclude -f root / --nr-backups 3
