#!/usr/bin/env bash

# fail on first error code
# set -e # doesn't work as expected

# Calls to this script must have a game server name (./test.sh server)
gameserver=$1

if [[ "${gameserver}" == "" ]]; then
    echo "Usage: ./test.sh [server]"
    exit 1
fi

# Add architecture i386 just in case it's not already enabled
sudo dpkg --add-architecture i386;

wget -O linuxgsm.sh https://raw.githubusercontent.com/Bourne-ID/LinuxGSM/devops/defaultcheck/linuxgsm.sh
chmod +x linuxgsm.sh
# !!!TODO: Temporary workaround for broken linuxgsm
bash linuxgsm.sh list > /dev/null
bash linuxgsm.sh "${gameserver}"

. ${gameserver}server ai

result=$?
# Todo parse result
echo "starting server"
sh ${gameserver}server start
result=$?
exit $result
