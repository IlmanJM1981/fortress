#!/bin/bash
# 👁️ THE APOSTLE'S EYE: MASTER INSTALLER (v1.1.8)
# Author: Jesse Miller / Ilman Yong

TARGET_DIR="$HOME/Desktop/scripts"
TARGET_FILE="$TARGET_DIR/eye.sh"
BACKUP_FILE="$TARGET_DIR/eye_V1.1.8_STABLE_FINAL.sh"

# 1. TEMPORARY UNLOCK
[ -f "$BACKUP_FILE" ] && chmod 755 "$BACKUP_FILE"
[ -f "$TARGET_FILE" ] && chmod 755 "$TARGET_FILE"

# 2. REPAIR CORE LOGIC (v1.1.8 STABLE)
cat << 'INNER_EOF' > "$TARGET_FILE"
#!/bin/bash
# 👁️ THE APOSTLE'S EYE v1.1.8 STABLE
# Built by Jesse Miller / Ilman Yong
LEDGER="$HOME/Desktop/scripts/eye_history.log"
EXPORT_DIR="$HOME/Desktop/eye_exports"
mkdir -p "$EXPORT_DIR"
touch "$LEDGER"
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'; M='\033[1;35m'; C='\033[1;36m'; W='\033[1;37m'; NC='\033[0m'
CHECK="${G}✔${NC}"; CROSS="${R}✘${NC}"
get_ip() { curl -s --max-time 2 https://api.ipify.org || echo "OFFLINE"; }
clean_input() { echo "$1" | sed "s/[-() ']//g"; }
run_network_recon() {
    read -p "🎯 IP / DOMAIN: " RAW; T=$(clean_input "$RAW")
    echo -e "${C}[!] OS Discovery & Blacklist Check...${NC}"
    curl -s "https://dnsbl.info/dnsbl-database-check.php?IP=$T" | grep -qi "listed" && echo -e "${R}[!] BLACKLISTED${NC}" || echo -e "${CHECK} ${G}CLEAN${NC}"
    sudo nmap -T4 -Pn -F -O --host-timeout 25s "$T" | grep -E "open|PORT|OS details|Aggressive"
    echo -e "\n${B}[!] Running Whois...${NC}"
    whois "$T" | grep -Ei "Organization:|OrgName:|Country:|ISP:|AS[0-9]" | while read -r line; do echo -e "${B}$line${NC}"; done
    echo -e "\n${Y}[!] Running Traceroute (Destination Probe)...${NC}"
    TRACE_DATA=$(traceroute -w 1 -m 20 "$T" | grep -v "\* \* \*")
    echo -e "${Y}$(echo "$TRACE_DATA" | head -n 1)${NC}"
    echo -e "${Y}... (skipping intermediate nodes) ...${NC}"
    echo -e "${Y}$(echo "$TRACE_DATA" | tail -n 1)${NC}"
}
run_phone_recon() {
    read -p "🎯 PHONE: " RAW; T=$(clean_input "$RAW")
    echo -e "${C}[!] Extracting Carrier & VOIP Status...${NC}"
    phoneinfoga scan -n "$T"
    API_OUT=$(curl -s "https://htmlweb.ru/geo/api.php?json&tel=$T")
    echo -e "${C}[*] Carrier: ${W}$(echo "$API_OUT" | jq -r '.oper.name // "Unknown"')"
    echo -e "${C}[*] Line Type: ${W}$(echo "$API_OUT" | jq -r '.oper.descr // "Physical"')"
}
while true; do
    PUB_IP=$(get_ip); clear
    echo -e "${R}--- THE EYE IS OPEN: v1.1.8 STABLE ---${NC}"
    echo -e "${B}CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')% | ISP IP: [${G}$PUB_IP${B}]${NC}"
    echo -e "${W}--------------------------------------------------------${NC}"
    echo -e "${C}[p] Phone Recon      | [i] IP / Domain Recon"
    echo -e "${C}[m] MDOC Otis Probe  | [l] Local Wi-Fi Scan"
    echo -e "${C}[r] SELF-REPAIR      | [v] Visual Mode ON/OFF"
    echo -e "${W}--------------------------------------------------------${NC}"
    read -n 1 -s -r MENU_KEY
    case "$MENU_KEY" in
        p) run_phone_recon; read -p "[Enter]..." ;;
        i) run_network_recon; read -p "[Enter]..." ;;
        r) bash ~/Desktop/scripts/eye_installer.sh; break ;;
        *) exit 0 ;;
    esac
done
INNER_EOF

# 3. RE-LOCK
chmod +x "$TARGET_FILE"
cp "$TARGET_FILE" "$BACKUP_FILE"
chmod 555 "$BACKUP_FILE"
echo -e "\033[1;32m[✔] System Restored to v1.1.8 Stable.\033[0m"
