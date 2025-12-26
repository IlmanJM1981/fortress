#!/bin/bash
ABUSE_KEY="dea17afd47ff9f3e723893b216b39ed9a318391f01369fcfa82218aff1c3a780b7c6723027204257"
RED="\e[1;31m"; BLUE="\e[1;34m"; GRN="\e[1;32m"; YEL="\e[1;33m"; RST="\e[0m"
FRIENDS_FILE="/home/ilmanjm1981/Desktop/scripts/.friends_list"
touch "$FRIENDS_FILE"

get_intel() {
 echo -e "${BLUE}--- EYES OF THE DRAGON: $1 ---${RST}"
 curl -s "http://ip-api.com/line/$1?fields=status,country,city,isp,query"
 abuse=$(curl -s -G https://api.abuseipdb.com/api/v2/check --data-urlencode "ipAddress=$1" -H "Key: $ABUSE_KEY" -H "Accept: application/json")
 echo -e "REPUTATION: $(echo $abuse | jq -r '.data.abuseConfidenceScore')% Confidence"
 read -p "Press Enter..."
}

report_ip() {
 curl -s -G https://api.abuseipdb.com/api/v2/report --data-urlencode "ip=$1" --data-urlencode "categories=18,22" --data-urlencode "comment=Brute force detected." -H "Key: $ABUSE_KEY" -H "Accept: application/json" > /dev/null
}

while true; do
 clear
 rep=$(curl -s -H "Key: $ABUSE_KEY" -H "Accept: application/json" "https://api.abuseipdb.com/api/v2/check-blocklist?limit=1" | jq -r '.meta.totalItems // "0"')
 ghost=$(sysctl net.ipv4.icmp_echo_ignore_all | awk '{print $3}')
 [[ "$ghost" -eq "1" ]] && GHOST_TAG=" | 👻 GHOST" || GHOST_TAG=""
 echo -e "${RED}--- FORTRESS OF ILMAN YONG v1.0 ---${RST}"
 cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}'); mem=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
 port=$(grep "^Port " /etc/ssh/sshd_config | awk '{print $2}')
 echo -ne "${BLUE}CPU: ${cpu}% | RAM: ${mem}% | PORT: ${port:-22} | REP: $rep${GHOST_TAG}${RST}"
 gst=$(who | awk '{print $NF}' | tr -d '()' | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | head -n 1)
 [[ -n "$gst" ]] && grep -q "$gst" "$FRIENDS_FILE" && echo -ne " | ${GRN}● GUEST: $gst${RST}"
 echo -e "\n------------------------------------------------------------------------------------------"
 echo -e "HITS   | IP ADDRESS      | CC  | STATUS | THREAT ASSESSMENT"
 echo "------------------------------------------------------------------------------------------"
 sudo grep "Failed password" /var/log/auth.log | grep -v "COMMAND" | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sort | uniq -c | sort -nr | head -n 40 | while read hits ip; do
  geo=$(curl -s "http://ip-api.com/json/$ip?fields=proxy,hosting,countryCode")
  cc=$(echo $geo | jq -r '.countryCode // "??"')
  if grep -q "$ip" "$FRIENDS_FILE"; then flag="🛡️ FRIEND"; desc="IRON CIRCLE"
  elif grep -q "$ip" /var/log/honeypot.log 2>/dev/null; then flag="🕸️ SNARLED"; desc="AUTO-BANNED"
  elif [ "$(echo $geo | jq -r '.proxy')" == "true" ]; then flag="🚩 BS    "; desc="Proxy/VPN"
  else flag="✅ OK    "; desc="Residential"; fi
  printf "${YEL}%-6s${RST} | %-15s | %-3s | %-10s | %s\n" "$hits" "$ip" "$cc" "$flag" "$desc"
 done
 echo "------------------------------------------------------------------------------------------"
 echo -e "${RED}--- LIVE SPIDER WEB ---${RST}"
 [ -f /var/log/honeypot.log ] && tail -n 3 /var/log/honeypot.log || echo "Waiting..."
 echo "------------------------------------------------------------------------------------------"
 echo -e "CMDS: b (Ban) | f (Friend) | e (Eyes) | n (Nuke) | ghost | clear-web | shields-up/down | q"
 read -p "Execute: " in
 cmd=$(echo "$in" | awk '{print $1}'); tgt=$(echo "$in" | awk '{print $2}')
 if [[ "$cmd" == "b" ]]; then sudo ban-hammer "$tgt"; report_ip "$tgt"; sleep 1
 elif [[ "$cmd" == "f" ]]; then echo "$tgt" >> "$FRIENDS_FILE" && sleep 1
 elif [[ "$cmd" == "e" ]]; then get_intel "$tgt"
 elif [[ "$cmd" == "ghost" ]]; then ./ghost-toggle.sh && sleep 1
 elif [[ "$cmd" == "clear-web" ]]; then sudo truncate -s 0 /var/log/honeypot.log && sleep 1
 elif [[ "$cmd" == "n" ]]; then sudo grep "Failed password" /var/log/auth.log | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sort | uniq | head -n 10 | while read rip; do if ! grep -q "$rip" "$FRIENDS_FILE"; then sudo ban-hammer "$rip"; report_ip "$rip"; fi; done; sleep 1
 elif [[ "$cmd" == "shields-up" ]]; then ./shields-up.sh && sleep 1
 elif [[ "$cmd" == "shields-down" ]]; then ./shields-down.sh && sleep 1
 elif [[ "$cmd" == "q" ]]; then exit 0; fi
done
