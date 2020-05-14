#!/bin/sh

first_eth=$(for i in /proc/sys/net/ipv4/conf/enp*; do basename "$i"; break; done)
status=$(ip link show dev "$first_eth" | head -n1 | awk '{ print $9 }')

if [ "$status" = "DOWN" ]; then
  echo ""
else
  ip_addr=$(ip address show "$first_eth" | grep inet | head -n1 | awk '{ print $2 }' | sed 's/\/24//g')
  echo "$ip_addr "
fi

