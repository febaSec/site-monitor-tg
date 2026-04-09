function tg_notify() {
	#  Verify internet connection 
	local HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.telegram.org/bot$TG_TOKEN/getMe")
	if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
		echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] No internet connection (HTTP $HTTP_CODE)" >> "$LOG_FILE"
		return 2
	fi
	if [[ "$HTTP_CODE" != "200" ]]; then
		echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] API connection failed (HTTP $HTTP_CODE)" >> "$LOG_FILE"
		return 1
	fi
        if ! curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/getMe" | jq -e ".ok" >/dev/null 2>&1; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] The telegram chat cannot be achieved" >> "$LOG_FILE"
        	return 1
	fi

	# Send message
	local message="$1"
	curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
         --data-urlencode "chat_id=$CHAT_ID" \
         --data-urlencode "text=$message" >/dev/null
}
