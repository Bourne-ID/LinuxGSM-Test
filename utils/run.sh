#!/usr/bin/env bash

# fail on first error code
# set -e # doesn't work as expected

# Calls to this script must have a game server name (./test.sh server)
gameserver=$1

if [[ "${gameserver}" == "" ]]; then
    echo "Usage: ./run.sh [server]"
    exit 1
fi
bash ${gameserver}server start

result=$?
# Todo parse result

exit $result
