#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Rerun as root" 1>&2
    sudo $0
    exit 0
fi

echo "Normal run as root"

set -x

. /etc/wireguard/ip.conf

ip link del dev wg0 || true

ip link add dev wg0 type wireguard
ip address add dev wg0 $ME peer $OTHER
ip -6 address add dev wg0 $ME6 peer $OTHER6
wg setconf wg0 /etc/wireguard/wg.conf
ip link set up dev wg0

