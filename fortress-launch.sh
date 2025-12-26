#!/bin/bash
# FORTRESS INTEL - ZEN PRIEST VIGILANCE

BANNER_COLOR="\e[1;31m" 
ZEN_COLOR="\e[1;34m"    
RESET="\e[0m"

clear
echo -e "${BANNER_COLOR}FORTRESS INTEL: ZEN PRIEST & DRAGONBLOOD APOSTLE${RESET}"
echo "----------------------------------------------------------------------------------------------------"
echo -e "HITS   | IP ADDRESS      | COUNTRY       | STATE         | CITY          | ISP / ORG"
echo "----------------------------------------------------------------------------------------------------"

# The Core Logic: Pull top 50 failed attempts from auth.log
sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 50 | while read hits ip; do
    # Pulling specific fields: Country, RegionName (State), City, and ISP
    data=$(curl -s "http://ip-api.com/json/$ip?fields=country,regionName,city,isp")
    country=$(echo $data | jq -r '.country')
    state=$(echo $data | jq -r '.regionName')
    city=$(echo $data | jq -r '.city')
    isp=$(echo $data | jq -r '.isp')

    # Formatting the visual columns with HITS, IP, Country, State, City, ISP
    printf "\e[1;33m%-6s\e[0m | %-15s | %-13s | %-13s | %-13s | %s\n" "$hits" "$ip" "$country" "$state" "$city" "$isp"
done

echo "----------------------------------------------------------------------------------------------------"
echo "COMMANDS: [IP] (Ban Hammer) | n (Nuke Top 10) | h (Honeypot Log) | q (Quit)"
echo "----------------------------------------------------------------------------------------------------"

while true; do
    read -p "Apostle Execute: " cmd ip_addr
    
    if [[ $cmd =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        sudo ban-hammer "$cmd"
    else
        case $cmd in
            n) 
                echo "Nuking top 10 threats..."
                sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}' | while read rip; do
                    sudo ban-hammer "$rip"
                done ;;
            h) 
                echo "--- Port 2222 Honeypot Hits ---"
                tail -n 20 /var/log/honeypot.log || echo "Honeypot log empty." ;;
            q) exit 0 ;;
            *) echo "The Dragon does not recognize that command." ;;
        esac
    fi
done
