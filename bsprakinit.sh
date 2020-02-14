#!/usr/bin/env bash

function ctrl_c() {
    echo "** Trapped CTRL-C"
	echo "[*] Restoring old rules..."
    systemctl stop dhcpd4.service
    systemctl stop xinetd.service
    ip addr delete 192.168.178.43/24 dev enp2s0
    ip link set down dev enp2s0
	exit
}

trap ctrl_c INT

ip link set up dev enp2s0
ip addr add 192.168.178.43/24 dev enp2s0

systemctl start dhcpd4.service
systemctl start xinetd.service

picocom -b 115200 /dev/ttyUSB0
ctrl_c
