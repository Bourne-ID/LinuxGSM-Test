#!/usr/bin/env bash

# Calls to this script must have a game server name (./test.sh server)
gameserver=$1

if [[ "${gameserver}" == "" ]]; then
    echo "Usage: ./test.sh [server]"
    exit 1
fi

# Add architecture i386 just in case it's not already enabled
sudo dpkg --add-architecture i386;

wget -O linuxgsm.sh https://linuxgsm.sh
chmod +x linuxgsm.sh
bash linuxgsm.sh "${gameserver}"

. ${gameserver} ai

result=$?
exit $result