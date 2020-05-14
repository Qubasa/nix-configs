#!/bin/sh
set -e

VPN=""
if  [ -e "/proc/sys/net/ipv4/conf/labs-vpn" ]; then
  VPN="Labs-VPN"
elif [ -e "/proc/sys/net/ipv4/conf/office-vpn" ]; then
  VPN="Office-VPN"
elif [ -e "/proc/sys/net/ipv4/conf/tun0" ]; then
  VPN="UKN-VPN"
elif [ -e "/proc/sys/net/ipv4/conf/wireguard-home" ]; then
  VPN="Home-VPN"
elif [ -e "/proc/sys/net/ipv4/conf/home-ovpn" ]; then
  VPN="Home-VPN"
fi

if [ "$VPN" = "" ]; then
  echo "VPN "
else
  echo "$VPN "
fi
