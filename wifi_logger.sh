#!/bin/bash

LOGFILE="wifi_log.csv"
INTERVAL_MINUTES=15  # Change this as needed

# If the file does not exist, add a header
if [ ! -f "$LOGFILE" ]; then
    echo "Timestamp,SSID" > "$LOGFILE"
fi

while true; do
    # Get current time
    CURRENT_TIME=$(date "+%s")  # Epoch time in seconds
    CURRENT_MINUTE=$(date "+%M")
    CURRENT_SECOND=$(date "+%S")

    # Calculate the next interval minute (00, 15, 30, 45)
    NEXT_MINUTE=$(( (CURRENT_MINUTE / INTERVAL_MINUTES + 1) * INTERVAL_MINUTES % 60 ))

    # Calculate seconds to sleep until the next interval (aligned to :00 seconds)
    SLEEP_TIME=$(( (NEXT_MINUTE - CURRENT_MINUTE + 60) % 60 * 60 - CURRENT_SECOND ))

    echo "Sleeping for $SLEEP_TIME seconds to align with the interval..."
    sleep "$SLEEP_TIME"

    # Log after waking up
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:00")  # Force seconds to 00
    SSID=$(ipconfig getsummary en0 | grep " SSID " | awk -F' : ' '{print $2}')

    echo "\"$TIMESTAMP\",\"$SSID\"" >> "$LOGFILE"
    echo "Logged: $TIMESTAMP - $SSID"
done