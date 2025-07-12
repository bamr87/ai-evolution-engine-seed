#!/bin/bash
# scripts/update-evolution-metrics.sh
# Updates daily evolution metrics

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"

log_info "Recording daily evolution metrics..."

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

log_success "Daily evolution metrics recorded for $TODAY"
