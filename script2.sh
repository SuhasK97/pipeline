#!/bin/bash

# Usage: ./ping_retry_util.sh <host> <max_retries> <delay_seconds>

HOST=$1
MAX_RETRIES=$2
DELAY=$3

# Validate input
if [ $# -ne 3 ]; then
    echo "Usage: $0 <host> <max_retries> <delay_seconds>"
    exit 1
fi

ping_retry() {
    attempt=1

    while [ $attempt -le $MAX_RETRIES ]
    do
        echo "Attempt $attempt: Pinging $HOST..."

        ping -c 1 "$HOST" > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            echo "SUCCESS: $HOST is reachable"
            return 0
        else
            echo "FAILED: Retry in $DELAY seconds..."
            sleep $DELAY
        fi

        attempt=$((attempt + 1))
    done

    echo "ERROR: $HOST is unreachable after $MAX_RETRIES attempts"
    return 1
}

# Call function
ping_retry

