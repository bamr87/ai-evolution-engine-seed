#!/bin/bash
# scripts/plant-new-seeds.sh
# Generates and commits new .seed.md for next evolution

set -euo pipefail

RESPONSE_FILE="${1:-/tmp/evolution_response.json}"
AUTO_PLANT="${2:-true}"

if [ "$AUTO_PLANT" != "true" ]; then
    echo "🌰 Seed planting disabled, skipping..."
    exit 0
fi

echo "🌰 Generating next generation .seed.md..."

if [ ! -f "$RESPONSE_FILE" ]; then
    echo "❌ Error: Response file not found: $RESPONSE_FILE"
    exit 1
fi

NEXT_SEED_CONTENT=$(jq -r .next_seed_content "$RESPONSE_FILE")

echo -e "$NEXT_SEED_CONTENT" > .seed.md
echo "✓ New .seed.md generated for the next evolutionary cycle."

# Get current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Extract growth cycle for commit message
GROWTH_CYCLES=$(jq -r '.changes[] | select(.path=="evolution-metrics.json") | .content' "$RESPONSE_FILE" | jq -r '.growth_cycles // "unknown"')

git add .seed.md
if git commit -m "🌰 Planted new seed for next evolution (post cycle $GROWTH_CYCLES)"; then
    echo "✅ New seed committed successfully"
    if git push origin "$CURRENT_BRANCH" 2>/dev/null; then
        echo "🚀 New seed pushed to branch"
    else
        echo "⚠️  Could not push to branch (may already be up-to-date)"
    fi
else
    echo "⚠️  No changes to .seed.md or commit failed"
fi
