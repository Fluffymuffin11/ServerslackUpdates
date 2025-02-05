#!/bin/bash

# Set your Slack webhook URL
SLACK_WEBHOOK="https://YOURSLACKWEBHOOK"

# Get system info
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
CPU_LOAD=$(top -bn1 | grep "load average" | awk '{print "Load Average: " $10 $11 $12}')
MEMORY_USAGE=$(free -h | awk '/Mem:/ {print "Memory Used: " $3 " / " $2}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print "Disk Used: " $3 " / " $2}')

# Get logged-in users
LOGGED_IN_USERS=$(who)

# Get recent SSH login attempts (last 10)
SSH_ATTEMPTS=$(sudo journalctl -u ssh --no-pager --since "1 hour ago" | grep "Accepted\|Failed" | tail -n>

# Get recent Fail2Ban bans (last 10)
FAIL2BAN_LOG=$(sudo journalctl -u fail2ban --no-pager --since "1 hour ago" | grep "Ban" | tail -n 10)

# Construct message
MESSAGE="🚀 *Server Status Report*\n
🔹 *Hostname:* $HOSTNAME\n
⏳ *Uptime:* $UPTIME\n
📊 *System Usage:*\n$CPU_LOAD\n$MEMORY_USAGE\n$DISK_USAGE\n
👤 *Logged-in Users:*\n$LOGGED_IN_USERS\n
🔐 *Recent SSH Login Attempts:*\n$SSH_ATTEMPTS\n
🚫 *Recent Fail2Ban Bans (Possible Nmap scans):*\n$FAIL2BAN_LOG"

# Send message to Slack
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$MESSAGE\"}" "$SLACK_WEBHOOK"