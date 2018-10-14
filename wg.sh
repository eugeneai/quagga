#!/bin/bash

set -x

. /etc/wireguard/ip.conf

if [[ $EUID -ne 0 ]]; then
    echo "Rerun as root" 1>&2
    sudo $0
    exit 0
fi

echo "Normal run as root"

ip link add dev wg0 type wireguard
ip address add dev wg0 $ME peer $OTHER
wg setconf wg0 /etc/wireguard/wg.conf
ip link set up dev wg0

