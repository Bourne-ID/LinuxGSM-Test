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

body="{
\"request\": {
\"branch\":\"${TRAVIS_BRANCH}\",
\"config\": }
  \"env\": {
    \"matrix\": [\"SERVER=${SERVER}\"]
  },
  \"script\": \"utils\test.sh \$SERVER\"
}
}}"

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token ${TRAVISAPI}" \
   -d "$body" \
   https://api.travis-ci.com/repo/Bourne-ID%2FLinuxGSM-Test/requests