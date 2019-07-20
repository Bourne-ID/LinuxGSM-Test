#!/usr/bin/env bash
#USAGE: ./build.sh [Dockerfile location]

tag="${line///Dockerfile/}"
# Remove ./
tag="${tag:2}"
# Replace special chars with -
tag="${tag//[\/\.]/-}"  #ubuntu-14-04

# Docker build

docker build -t "bourneid/linuxgsm-test:${tag}" ${line}
if [[ $? -ne 0 ]]; then
    exit 1
fi

docker login -u "${QUAY_BOT_USERNAME}" -p "{$QUAY_BOT_PASSWORD}" quay.io
docker push quay.io/bourneid/linuxgsm-test:${tag}