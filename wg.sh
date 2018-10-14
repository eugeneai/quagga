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
ip link set up dev wg0
ip addr flush dev wg0
ip address add dev wg0 $ME peer $OTHER
ip -6 address add dev wg0 $ME6 peer $OTHER6
# ip -6 address add dev wg0 $MEU6 peer $OTHERU6
wg setconf wg0 /etc/wireguard/wg.conf

ip tunnel del gre_g || true
ip tunnel add gre_g mode gre local $MEGL remote $OTHERGL ttl 255
ip addr add dev gre_g $MEG peer $OTHERG
ip -6 addr add dev gre_g $MEG6 peer $OTHERG6
ip link set dev gre_g up

