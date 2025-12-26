#!/bin/bash
# FORTRESS OF ILMAN YONG - ESCALATION REPORTER

ABUSE_KEY="dea17afd47ff9f3e723893b216b39ed9a318391f01369fcfa82218aff1c3a780b7c6723027204257"
EMAIL="IlmanJM1981@gmail.com"

# Monitor the honeypot log for new Auto-Bans
tail -Fn0 /var/log/honeypot.log | while read line; do
    if [[ "$line" == *"AUTO-BAN"* ]]; then
        IP=$(echo "$line" | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
        
        # Pull Abuse Intel for the report
        SCORE=$(curl -s -G https://api.abuseipdb.com/api/v2/check --data-urlencode "ipAddress=$IP" -H "Key: $ABUSE_KEY" -H "Accept: application/json" | jq -r '.data.abuseConfidenceScore // "Unknown"')
        
        # Send the Email
        echo -e "The Fortress has neutralized a threat.\n\nIP: $IP\nAbuse Confidence: $SCORE%\nLog Entry: $line\n\nThe Spider Web has been reset." | mail -s "🛡️ FORTRESS ALERT: IP SNARLED ($IP)" $EMAIL
    fi
done
