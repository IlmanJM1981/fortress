#!/bin/bash
echo "--- STOPPING TCPDUMP & DISABLING FIREWALL LOGGING ---"
# This will stop tcpdump without closing the window immediately
sudo pkill -f "tcpdump -i any icmp"
echo "Tcpdump process stopped."
sudo ufw logging off
echo "Firewall logging is now OFF."
read -p "Press Enter to close this window..."
