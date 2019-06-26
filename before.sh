#!/usr/bin/env bash
# Get serverlist.csv from linuxgsm
wget https://raw.githubusercontent.com/Bourne-ID/LinuxGSM/devops/defaultcheck/lgsm/data/serverlist.csv -O serverlist.csv

IFS=","
while read shortcode servercode servername steam; do
    if [[ $steam == false ]]; then
        export SERVER=${shortcode}
        echo "$SERVER"
    fi
done < serverlist.csv