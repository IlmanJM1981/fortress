#!/bin/bash
echo "--- ENABLING FIREWALL LOGGING & STARTING RECON DETECTOR ---"
sudo ufw logging low
echo "Firewall logging is now ON (low)."
echo ""
echo "Watching for Pings, Traceroutes, and TCP Port Scans..."
echo "Press Ctrl+C in this window to stop."
echo ""

# This filter looks for three things:
# 1. ICMP echo requests (pings)
# 2. UDP packets in the common traceroute port range
# 3. TCP packets that are ONLY a SYN request (common for port scans)
sudo tcpdump -i any -n '(icmp and icmp[icmptype] = icmp-echo) or (udp and dst portrange 33434-33534) or (tcp[tcpflags] & tcp-syn != 0 and tcp[tcpflags] & tcp-ack == 0)'
