#!/bin/bash
# FORTRESS INTEL - ZEN PRIEST VIGILANCE

BANNER_COLOR="\e[1;31m" 
ZEN_COLOR="\e[1;34m"    
RESET="\e[0m"

# --- THE MISSING POWER: EYES OF THE DRAGON ---
get_intel() {
    local ip=$1
    if [[ -z "$ip" ]]; then echo -e "Provide an IP."; sleep 1; return; fi
    echo -e "${ZEN_COLOR}--- EYES OF THE DRAGON: $ip ---${RESET}"
    curl -s "http://ip-api.com/line/$ip?fields=status,message,country,regionName,city,isp,as,proxy,query"
    echo -e "${ZEN_COLOR}------------------------------${RESET}"
    read -p "Press Enter to return..."
}

while true; do
    clear
    echo -e "${BANNER_COLOR}FORTRESS INTEL: ZEN PRIEST & DRAGONBLOOD APOSTLE${RESET}"
    echo "----------------------------------------------------------------------------------------------------"
    echo -e "HITS   | IP ADDRESS      | COUNTRY       | STATE         | CITY          | ISP / ORG"
    echo "----------------------------------------------------------------------------------------------------"

    sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 50 | while read hits ip; do
        data=$(curl -s "http://ip-api.com/json/$ip?fields=country,regionName,city,isp")
        country=$(echo $data | jq -r '.country')
        state=$(echo $data | jq -r '.regionName')
        city=$(echo $data | jq -r '.city')
        isp=$(echo $data | jq -r '.isp')
        printf "\e[1;33m%-6s\e[0m | %-15s | %-13s | %-13s | %-13s | %s\n" "$hits" "$ip" "$country" "$state" "$city" "$isp"
    done

    echo "----------------------------------------------------------------------------------------------------"
    # THE UPDATED MENU
    echo -e "COMMANDS: [IP] (Ban Hammer) | e [IP] (Eyes) | n (Nuke Top 10) | h (Honeypot Log) | q (Quit)"
    echo "----------------------------------------------------------------------------------------------------"

    read -p "Apostle Execute: " input
    cmd=$(echo $input | awk '{print $1}')
    target=$(echo $input | awk '{print $2}')

    if [[ $cmd =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        sudo ban-hammer "$cmd"
    else
        case $cmd in
            e) get_intel "$target" ;;
            n) 
                sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}' | while read rip; do
                    sudo ban-hammer "$rip"
                done ;;
            h) 
                if [ -f /var/log/honeypot.log ]; then tail -n 20 /var/log/honeypot.log; else echo "Honeypot log empty."; fi
                read -p "Press Enter..." ;;
            q) exit 0 ;;
            *) echo "Invalid Command." ; sleep 1 ;;
        esac
    fi
done
