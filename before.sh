#!/usr/bin/env bash
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }

declare -a servers
# Get serverlist.csv from linuxgsm
wget https://raw.githubusercontent.com/Bourne-ID/LinuxGSM/devops/defaultcheck/lgsm/data/serverlist.csv -O serverlist.csv

IFS=","
while read shortcode servercode servername steam; do
    if [[ $steam == false ]]; then
        servers+=("${shortcode}")
    fi
done < serverlist.csv
serverlist=$(join_by "\",\"SERVER=" "${servers[@]}")

body="{
\"request\": {
  \"branch\":\"${TRAVIS_BRANCH}\",
  \"config\": {
    \"env\": {
      \"matrix\": [\"SERVER=${serverlist}\"]
    },
    \"script\": [\"\$TRAVIS_BUILD_DIR/utils/test.sh \$SERVER\", \"\$TRAVIS_BUILD_DIR/utils/test.sh \$SERVER\"]
  }
}}"
echo "${body}"

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token ${TRAVISAPI}" \
   -d "$body" \
   https://api.travis-ci.org/repo/Bourne-ID%2FLinuxGSM-Test/requests
