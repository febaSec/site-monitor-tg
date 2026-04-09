#!/bin/bash
set -euo pipefail

# Enable config
source ./src/sentinel.conf
source ./src/dependencies.sh
source ./src/tg_notify.sh
source ./src/colors.sh
# Trap for errors
trap 'echo "[ERROR] Script failed at line $LINENO" >> "$LOG_FILE"' ERR

# Dependencies
dependencies

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

