#!/bin/bash
# scripts/update-evolution-metrics.sh
# Updates daily evolution metrics

set -euo pipefail

echo "📊 Recording daily evolution metrics..."

# Create or update daily evolution log
DAILY_LOG="daily-evolution-log.json"
TODAY=$(date -u +%Y-%m-%d)

# Initialize log if it doesn't exist
if [ ! -f "$DAILY_LOG" ]; then
    echo '{"daily_runs": {}}' > "$DAILY_LOG"
fi

# Update today's entry
jq --arg date "$TODAY" \
   --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
   '.daily_runs[$date] = {
     "timestamp": $timestamp,
     "triggered": true,
     "status": "completed"
   }' "$DAILY_LOG" > "${DAILY_LOG}.tmp" && mv "${DAILY_LOG}.tmp" "$DAILY_LOG"

echo "✅ Daily evolution metrics recorded for $TODAY"
