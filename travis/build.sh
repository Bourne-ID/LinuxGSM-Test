#!/usr/bin/env bash
#USAGE: ./build.sh [Dockerfile location]
line=$1
line="${line///Dockerfile/}"
# Remove ./
tag="${line:2}"
# Replace special chars with -
tag="${tag//[\/\.]/-}"  #ubuntu-14-04

# Docker build
cd docker

docker build -t "bourneid/linuxgsm-test:${tag}" ${line}

if [[ $? -ne 0 ]]; then
    exit 1
fi

docker login -u "${QUAY_BOT_USERNAME}" -p "{$QUAY_BOT_PASSWORD}" quay.io
docker push quay.io/bourneid/linuxgsm-test:${tag}
