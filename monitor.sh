#!/bin/bash

# ==========================
# Configuration
# ==========================
EMAIL="cloudsreprep09@gmail.com"
LOG_FILE="/var/log/system_metrics.log"

CPU_THRESHOLD=90
DISK_THRESHOLD=85
MEM_PERCENT_THRESHOLD=90
MEM_AVAILABLE_THRESHOLD=500   # in MB (adjust based on server size)

# ==========================
# Get Metrics
# ==========================

# CPU usage (%)
CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*}

# Memory usage
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/^Mem:/ {print $3}')
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')
MEM_PERCENT=$(free | awk '/^Mem:/ {printf("%.0f", $3/$2 * 100)}')

# Disk usage (%)
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

# Timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# ==========================
# Check Thresholds
# ==========================

ALERT_MSG=""

# CPU
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    ALERT_MSG+="High CPU usage: ${CPU_USAGE}%\n"
fi

# Disk
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    ALERT_MSG+="High Disk usage: ${DISK_USAGE}%\n"
fi

# Memory (improved logic)
if [ "$MEM_PERCENT" -gt "$MEM_PERCENT_THRESHOLD" ] || [ "$MEM_AVAILABLE" -lt "$MEM_AVAILABLE_THRESHOLD" ]; then
    ALERT_MSG+="High Memory usage: ${MEM_USED}MB (${MEM_PERCENT}%), Available: ${MEM_AVAILABLE}MB\n"
fi

# ==========================
# Alert or Log
# ==========================

if [ -n "$ALERT_MSG" ]; then
    MESSAGE="ALERT at $TIMESTAMP\n\n$ALERT_MSG\nFull Stats:\nCPU: ${CPU_USAGE}%\nMemory: ${MEM_USED}MB (${MEM_PERCENT}%)\nAvailable Memory: ${MEM_AVAILABLE}MB\nDisk: ${DISK_USAGE}%"

    echo -e "$MESSAGE" | mail -s "System Alert on $(hostname)" "$EMAIL"

    echo -e "$TIMESTAMP ALERT | CPU: ${CPU_USAGE}% | MEM: ${MEM_USED}MB (${MEM_PERCENT}%) | AVAIL: ${MEM_AVAILABLE}MB | DISK: ${DISK_USAGE}%" >> $LOG_FILE
else
    echo "$TIMESTAMP OK | CPU: ${CPU_USAGE}% | MEM: ${MEM_USED}MB (${MEM_PERCENT}%) | AVAIL: ${MEM_AVAILABLE}MB | DISK: ${DISK_USAGE}%" >> $LOG_FILE
fi
