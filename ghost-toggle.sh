#!/bin/bash
STATUS=$(sysctl net.ipv4.icmp_echo_ignore_all | awk '{print $3}')
if [ "$STATUS" -eq "0" ]; then sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1 > /dev/null; echo "GHOST ACTIVE";
else sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0 > /dev/null; echo "GHOST INACTIVE"; fi
