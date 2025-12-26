#!/bin/bash
echo "--- CHECKING UFW LOGS FOR PING ATTEMPTS (ICMP) ---"
echo ""
sudo grep --color=always "PROTO=ICMP" /var/log/ufw.log || echo "No ICMP log entries found."
echo ""
read -p "Press Enter to close this window..."
