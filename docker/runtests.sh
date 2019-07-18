#!/bin/bash
# Make sure a game server has been provided
if [[ $# -eq 0 ]]; then
    echo "USAGE: $0 [server]"
    exit 1
fi

# PROVISION
./linuxgsm.sh $1
# AUTO_INSTALL
bash ./$1 ai
# START
bash ./$1 start
sleep 60 #TODO: Make this smarter
bash ./$1 monitor