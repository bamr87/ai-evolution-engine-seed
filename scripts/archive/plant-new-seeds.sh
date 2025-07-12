#!/bin/bash
# scripts/plant-new-seeds.sh
# Generates and commits new .seed.md for next evolution

set -euo pipefail

# Source modular libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source logger
source "$PROJECT_ROOT/src/lib/core/logger.sh"

# Source environment detection
source "$PROJECT_ROOT/src/lib/utils/env_detect.sh"

RESPONSE_FILE="${1:-/tmp/evolution_response.json}"
AUTO_PLANT="${2:-true}"

if [ "$AUTO_PLANT" != "true" ]; then
    log_info "Seed planting disabled, skipping..."
    exit 0
fi

log_info "Generating next generation .seed.md..."

if [ ! -f "$RESPONSE_FILE" ]; then
    log_error "Response file not found: $RESPONSE_FILE"
    exit 1
fi

NEXT_SEED_CONTENT=$(jq -r .next_seed_content "$RESPONSE_FILE")

echo -e "$NEXT_SEED_CONTENT" > .seed.md
log_success "New .seed.md generated for the next evolutionary cycle."

# Get current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Extract growth cycle for commit message
GROWTH_CYCLES=$(jq -r '.changes[] | select(.path=="evolution-metrics.json") | .content' "$RESPONSE_FILE" | jq -r '.growth_cycles // "unknown"')

git add .seed.md
if git commit -m "🌰 Planted new seed for next evolution (post cycle $GROWTH_CYCLES)"; then
    log_success "New seed committed successfully"
    if git push origin "$CURRENT_BRANCH" 2>/dev/null; then
        log_success "New seed pushed to branch"
    else
        log_warn "Could not push to branch (may already be up-to-date)"
    fi
else
    log_warn "No changes to .seed.md or commit failed"
fi
