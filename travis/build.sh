#!/usr/bin/env bash
#USAGE: ./build.sh [Dockerfile location]

file=$1
echo "Input: ${file}"
line="${file///Dockerfile/}"
# Remove ./
tag="${line:2}"
# Replace special chars with -
tag="${tag//[\/\.]/-}"  #ubuntu-14-04

echo "Tag: ${tag}"
# Docker build
cd docker

pwd=$(pwd)
echo "PWD: ${pwd}"
docker build -t "bourneid/linuxgsm-test:${tag}" -f ${file} .

if [[ $? -ne 0 ]]; then
    exit 1
fi

docker login -u "${QUAY_BOT_USERNAME}" -p "{$QUAY_BOT_PASSWORD}" quay.io
docker push quay.io/bourneid/linuxgsm-test:${tag}
