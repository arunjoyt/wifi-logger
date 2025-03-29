#!/bin/bash

LOGFILE="wifi_log.csv"
INTERVAL_MINUTES=15  # Change this as needed

# If the file does not exist, add a header
if [ ! -f "$LOGFILE" ]; then
    echo "Timestamp,SSID" > "$LOGFILE"
fi

while true; do
    CURRENT_TIME=$(date "+%s")  # Current time in seconds
    CURRENT_MINUTE=$(date "+%M")

    # Calculate the next logging time aligned to INTERVAL_MINUTES
    NEXT_MINUTE=$(( (CURRENT_MINUTE / INTERVAL_MINUTES + 1) * INTERVAL_MINUTES % 60 ))
    SLEEP_TIME=$(( (NEXT_MINUTE - CURRENT_MINUTE + 60) % 60 * 60 ))

    echo "Sleeping for $SLEEP_TIME seconds to align with the interval..."
    sleep "$SLEEP_TIME"

    # Log after waking up
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    SSID=$(ipconfig getsummary en0 | grep " SSID " | awk -F' : ' '{print $2}')

    echo "\"$TIMESTAMP\",\"$SSID\"" >> "$LOGFILE"
    echo "Logged: $TIMESTAMP - $SSID"
done