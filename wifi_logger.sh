#!/bin/bash

LOGFILE="wifi_log.csv"
INTERVAL_MINUTES=1  # Change this to any desired interval (e.g., 10 for every 10 minutes)

# If the file does not exist, add a header
if [ ! -f "$LOGFILE" ]; then
    echo "Timestamp,SSID" > "$LOGFILE"
fi

# Wait until the next multiple of INTERVAL_MINUTES
while true; do
    CURRENT_MINUTE=$(date "+%M")
    CURRENT_SECOND=$(date "+%S")

    if (( CURRENT_MINUTE % INTERVAL_MINUTES == 0 )); then
        break  # Start logging now
    fi

    SLEEP_TIME=$(( 60 - CURRENT_SECOND ))  # Sleep until the next minute
    echo "Waiting for the next ${INTERVAL_MINUTES}-minute mark..."
    sleep "$SLEEP_TIME"
done

# Start logging at the configured interval
while true; do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    SSID=$(ipconfig getsummary en0 | grep " SSID " | awk -F' : ' '{print $2}')

    echo "\"$TIMESTAMP\",\"$SSID\"" >> "$LOGFILE"
    echo "Logged: $TIMESTAMP - $SSID"

    sleep $(( INTERVAL_MINUTES * 60 ))  # Sleep based on the configured interval
done