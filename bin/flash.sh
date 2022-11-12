#!/usr/bin/env bash

flash() {
    case $1 in
        "Adv360 Pro")
            echo "$1:$left_file"
            cp "$left_file" /Volumes/ADV360PRO ;;
        "Adv360 Pro rt")
            echo "$1:$right_file"
            cp "$right_file" /Volumes/ADV360PRO ;;
        *)
            echo "Can't figure out string in UF2"
            echo "string: $1"
            exit 1 ;;
    esac
}

check_usb() {
    echo "Waiting for Adv 360 pro"
while true; do
    if test -f /Volumes/ADV360PRO/CURRENT.UF2; then
       break
    fi
    sleep 1
done

side="$(strings -n 10 /Volumes/ADV360PRO/CURRENT.UF2 | grep "Adv360 Pro" | head -1)"

flash "$side"
}

last_date="$(ls -1t firmware/ | head -1 |sed 's/\([0-9]*\)-[a-z]*.uf2/\1/')"

right_file="firmware/$last_date-right.uf2"
left_file="firmware/$last_date-left.uf2"

check_usb
sleep 2
check_usb
