#!/usr/bin/env bash
# Get serverlist.csv
wget https://github.com/Bourne-ID/LinuxGSM/blob/devops/defaultcheck/lgsm/data/serverlist.csv

IFS=","
while read shortcode servercode servername steam; do
    if [[ $steam == false ]]; then
        export SERVER=${shortcode}
    fi
done < serverlist.csv