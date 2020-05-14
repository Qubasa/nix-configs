#!/bin/sh

status=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')
volume=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')

if [ "$status" = "off" ]; then
  echo "Muted "
else
  echo "$volume "
fi
