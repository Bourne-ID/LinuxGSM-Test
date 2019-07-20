#!/usr/bin/env bash
set -e # Fail Fast
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
docker build -t "bourneid/linuxgsm-test:${tag}" -f ${file} .
docker login -u "${QUAY_BOT_USERNAME}" -p "{$QUAY_BOT_PASSWORD}" quay.io
docker tag bourneid/linuxgsm-test:${tag} quay.io/bourneid/linuxgsm-test:${tag}
docker push quay.io/bourneid/linuxgsm-test:${tag}
