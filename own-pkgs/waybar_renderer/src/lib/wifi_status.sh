#!/bin/sh

ssid=$(iwgetid -r)
quality=$(cat /proc/net/wireless | tail -n1 | awk '{ print $3}' | sed 's/\.//g')dB

if [ "$ssid" = "" ]; then
  echo "Wifi "
else
  echo "$quality at $ssid "
fi
