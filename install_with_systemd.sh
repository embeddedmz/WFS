#!/bin/sh

BINARY=wfs
CONFIG=wfs.conf
TARGETS=targets.txt
SYSTEMD_INITSCRIPT=systemd/system/wfs

BINARY_TARGET=/usr/bin
SYSTEMD_INITSCRIPT_TARGET=/etc/systemd/system
CONFIG_TARGET=/etc/wfs

if [ "$1" = "remove" ]
then
    systemctl disable wfs.service

    rm "$BINARY_TARGET/$BINARY"
    rm "$CONFIG_TARGET/$CONFIG"
    rm "$CONFIG_TARGET/$TARGETS"
    rm $SYSTEMD_INITSCRIPT_TARGET/`basename $SYSTEMD_INITSCRIPT`
    exit
fi

if [ ! -e "$CONFIG_TARGET" ]
then
    mkdir -p "$CONFIG_TARGET"
fi

cp "$BINARY" "$BINARY_TARGET"
cp "$SYSTEMD_INITSCRIPT" "$SYSTEMD_INITSCRIPT_TARGET"

chmod 755 "$BINARY_TARGET/$BINARY"
chmod 755 "$SYSTEMD_INITSCRIPT_TARGET/`basename $SYSTEMD_INITSCRIPT`"

if [ -e $CONFIG_TARGET/$CONFIG ]
then
    echo
    echo "-------------------------------------------------------------------"
    echo "Existing configuration found. Creating $CONFIG_TARGET/$CONFIG.new."
    echo "Update your existing configuration file with the new one or WFS may"
    echo "not operate properly due to changes. Press enter to continue."
    echo "-------------------------------------------------------------------"
    read
    cp "$CONFIG" "$CONFIG_TARGET/$CONFIG.new"
    cp "$TARGETS" "$CONFIG_TARGET/$TARGETS.new"
else
    cp "$CONFIG" "$CONFIG_TARGET/$CONFIG"
    cp "$TARGETS" "$CONFIG_TARGET/$TARGETS" 
fi

systemctl enable wfs.service
