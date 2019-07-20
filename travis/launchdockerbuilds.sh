#!/usr/bin/env bash

dockerfiles=$(find . -name Dockerfile -printf "FILE=%p\",\"")

    body="{
\"request\": {
  \"branch\":\"${TRAVIS_BRANCH}\",
  \"config\": {
    \"env\": {
      \"matrix\": [\"${dockerfiles::-2}\"]
    },
    \"script\": [\"\$TRAVIS_BUILD_DIR/travis/build.sh \$FILE\"]
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
