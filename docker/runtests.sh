#!/bin/sh
# PROVISION
./linuxgsm.sh fofserver
# AUTO_INSTALL
./fofserver ai
# START
./fofserver start
sleep 60 #TODO: Make this smarter
./fofserver monitor