#!/bin/bash
# This script adds NOTRACK rules for the specified ports in the firewalld
# Created by: Yevgeniy Goncharov aka xck, http://sys-adm.in

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd); cd ${SCRIPT_PATH}

# Check if firewalld is installed
if [ ! -f /usr/bin/firewall-cmd ]; then
    echo "Firewalld is not installed!"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "Usage: $0 <port1> <port2> ..."
    exit 1
fi

for port in "$@"; do

    # Check if port is number
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo "Port $port is not a number!"
        exit 1
    fi

    echo "Adding NOTRACK rules for port $port ..."

    # IPv4 rules
    firewall-cmd --direct --add-rule ipv4 raw PREROUTING 0 -p udp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv4 raw PREROUTING 0 -p udp --sport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv4 raw OUTPUT 0 -p udp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv4 raw OUTPUT 0 -p udp --sport $port -j NOTRACK

    firewall-cmd --direct --add-rule ipv4 raw PREROUTING 0 -p tcp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv4 raw PREROUTING 0 -p tcp --sport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv4 raw OUTPUT 0 -p tcp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv4 raw OUTPUT 0 -p tcp --sport $port -j NOTRACK

    # IPv6 rules
    firewall-cmd --direct --add-rule ipv6 raw PREROUTING 0 -p udp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv6 raw PREROUTING 0 -p udp --sport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv6 raw OUTPUT 0 -p udp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv6 raw OUTPUT 0 -p udp --sport $port -j NOTRACK

    firewall-cmd --direct --add-rule ipv6 raw PREROUTING 0 -p tcp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv6 raw PREROUTING 0 -p tcp --sport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv6 raw OUTPUT 0 -p tcp --dport $port -j NOTRACK
    firewall-cmd --direct --add-rule ipv6 raw OUTPUT 0 -p tcp --sport $port -j NOTRACK

    echo "Done."

done

# Additional rule if specified
if [ "$2" == "--allow" ]; then
    firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -p udp --dport $port -j ACCEPT
    firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -p tcp --dport $port -j ACCEPT
fi