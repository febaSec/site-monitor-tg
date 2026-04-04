# Title
Site-Monitor-TG


## Description 
Lightweight Bash tool for monitoring websites and system services with logging and Telegram alerts.

## Key Features
- Smart Web Checks: Monitors multiple URLs for status codes with configurable timeouts.
- Service Watchdog: Tracks systemd services and attempts automatic restarts on failure.
- Telegram Integration: Uses native API calls with URL-encoding for robust notification delivery.
- Security First: Validates API tokens before execution and uses secure environment handling.
- Detailed Logging: Every action, warning, and error is timestamped and logged for audit.
- Fail-Safe: Uses `set -euo pipefail` and `trap` for error handling.


## Security & Permissions
This script follows the Principle of Least Privilege. Instead of running the entire script as `root`, I recommend running it as a standard
user and granting specific permission to restart services without a password prompt.


#### 1. _Setup permissions_

1. Check where the systemctl executable is located

```shell
 which systemctl
```

> The output will show you the file path. Copy it

2. Go to configuration file

```shell
sudo visudo -f /etc/sudoers.d/sentinel
```

3. Add the following line (replace: your_user with the actual username, systemctl path with the actual path):

```shell
your_user ALL=(root) NOPASSWD: /usr/bin/systemctl restart *
```

#### 2. _Why this is better than running as root_:

- Isolation: The script handles network requests (Telegram API) with low-level user privileges.
- Controlled Access: Only the restart command is elevated, preventing accidental or malicious system-wide changes.
- Automation: The script remains fully autonomous and won't hang waiting for a password prompt.


## Installation

```shell
git clone https://github.com/febaSec/site-monitor-tg.git
cd site-monitor-tg
cp sentinel.conf.example sentinel.conf
chmod +x sentinel.sh
```

## Configuration
You now need to change the values of the variables in the sentinel.conf file: 

```shell
nano sentinel.conf
```
1. `TG_TOKEN` - you need to create a bot and replace the value with your personal API token.
2. `CHAT_ID` - To find out your chat number, send a message to the bot you’ve just created, and then enter the following command:
```shell
curl -s -X POST "https://api.telegram.org/bot<YOUR API TOKEN>/getUpdates" | jq ".result[].message.chat.id" | head -n1
```
> If you did not get ID. Try to send 1-2 more message in the bot-chat and repeate the command.
3. `URLS` - enter the urls you want to monitor separated by the space
4. `SERVICES` - enter the services name you want to monitor.


## Usage
There are two ways to use the script:

#### 1. Run it manualy (You need to be in directory with script):
```shell
./sentinel.sh
```

#### 2. Automation (Recommended)
Add to crontab to run every 5 minutes:
```shell
#silent mode
* * * * * /path/to/sentinel.sh >/dev/null 2>&1
```
> Be sure to add ` >/dev/null 2>&1` at the end, as shown in the example. This will suppress console output, so you won't have to comment out lines of code in sentinel.sh
```shell
# Log output (optional)
* * * * * /path/to/sentinel.sh >> /var/log/sentinel.log 2>&1
```
> This option will save all script output to sentinel.log. Be sure to specify the correct path to the log file.


## Example Output
- _The terminal will notify you when the script has started, as well as any issues it has encountered, for example:_
```shell
Sentinel-TG monitoring started...
The site [https://site-name.com] is down
Service down
Service restored
```

- _The script will also log events to `sentinel.log` file_
```txt
2026-04-04 10:08:08 [CRITICAL]  Site [https://site-name.com] is down. Code: 000000
2026-04-04 10:08:08 [WARNING] Service ssh is down. Attempting restart...
2026-04-04 10:08:09 [INFO] Service ssh restored
```

- _The script will also report errors in the Telegram chat_
```txt
🔴 ALERT: Site https://site-name.com is down! Code: 000000
⚠️   Service ssh is down. Attempting restart...
✅ Service ssh restored.
or
🚨 CRITICAL: Failed to restore ssh!
```


## Dependencies
- curl
- jq
- systemd (for service monitoring)


## How it Works
- Checks websites via HTTP requests
- Verifies system services using systemctl
- Sends alerts via Telegram
- Attempts automatic service recovery


## License 
This project is licensed under the MIT License. For more information read LICENSE.
