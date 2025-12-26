#!/bin/bash
# FORTRESS OF ILMAN YONG - SHIELD WALL MONTHLY REPORT

EMAIL="IlmanJM1981@gmail.com"
REPORT_FILE="/tmp/shield_wall_report.txt"

echo "--- FORTRESS OF ILMAN YONG: MONTHLY SHIELD WALL REPORT ---" > $REPORT_FILE
echo "Generated on: $(date)" >> $REPORT_FILE
echo "--------------------------------------------------------" >> $REPORT_FILE

# 1. Total Bans Captured
echo "TOTAL SPIDER WEB BANS: $(grep -c "AUTO-BAN" /var/log/honeypot.log)" >> $REPORT_FILE

# 2. Top 5 Attacker Countries (from auth.log)
echo -e "\nTOP ATTACKER ORIGINS:" >> $REPORT_FILE
sudo grep "Failed password" /var/log/auth.log | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort | uniq | xargs -I {} curl -s http://ip-api.com/line/{}?fields=country | sort | uniq -c | sort -nr | head -n 5 >> $REPORT_FILE

# 3. Email the report
mail -s "🛡️ MONTHLY SHIELD WALL SUMMARY" $EMAIL < $REPORT_FILE

# 4. Log Rotation (The Housecleaning)
# Keep only the last 1000 lines of the honeypot log to save space
tail -n 1000 /var/log/honeypot.log | sudo tee /var/log/honeypot.log > /dev/null
