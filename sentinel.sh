#!/bin/bash
set -euo pipefail

# Enable config
source sentinel.conf

# Trap for errors
trap 'echo "[ERROR] Script failed at line $LINENO" >> "$LOG_FILE"' ERR

# Commands check
for cmd in curl jq; do
	command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found"; exit 1; }
done

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Log and telegram notify function
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.telegram.org/bot$TG_TOKEN/getMe")
if [[ "$HTTP_CODE" != "200" ]]; then
    echo "[ERROR ] API connection failed (HTTP $HTTP_CODE)" >> "$LOG_FILE"
    exit 150
fi

if ! curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/getMe" | jq -e ".ok" >/dev/null 2>&1; then
	echo "[ERROR] The chat can't be achived" >> "$LOG_FILE"
fi

function tg_notify() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
         --data-urlencode "chat_id=$CHAT_ID" \
         --data-urlencode "text=$message" >/dev/null
}

# URLS array check
echo -e "${GREEN}Sentinel-TG monitoring started...${NC}"

for site in "${URLS[@]}"; do
	answ=$(curl -o /dev/null -s -L --max-time 10  --connect-timeout 5 -w "%{http_code}" "$site" || echo "000")
	if [[ ! "$answ" -eq 200 ]]; then
		echo -e "${RED}The site [$site] is down"
		echo "$(date '+%Y-%m-%d %H:%M:%S') [CRITICAL]  Site [$site] is down. Code: $answ" >> "$LOG_FILE"
		tg_notify "🔴 ALERT: Site $site is down! Code: $answ"
	fi
done

# SERVICES array check
for service in "${SERVICES[@]}"; do
	if ! systemctl is-active --quiet "$service"; then
		echo -e "${RED}Service down${NC}"
		echo -e "$(date '+%Y-%m-%d %H:%M:%S') [WARNING] Service $service is down. Attempting restart..." >> "$LOG_FILE"
		tg_notify "⚠️  Service $service is down. Attempting restart..."
		sudo systemctl restart "$service"
		if systemctl is-active --quiet "$service"; then
                	echo -e "${GREEN}Service restored${NC}"
                	echo -e "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Service $service restored" >> "$LOG_FILE"
                	tg_notify "✅ Service $service restored."
        	else
                	echo -e "${RED}Restoration failed${NC}"
                	echo -e "$(date '+%Y-%m-%d %H:%M:%S') [CRITICAL] Critical: Failed to restore $service" >> "$LOG_FILE"
                	tg_notify "🚨 CRITICAL: Failed to restore $service!"
        	fi
	fi
done

