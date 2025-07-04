#!/usr/bin/env bash
# scripts/generate_ai_response.sh
# Usage: generate_ai_response.sh NEW_CYCLE NEW_GENERATION PROMPT GROWTH_MODE NEW_METRICS_CONTENT README_MARKER_START README_MARKER_END README_DYNAMIC_CONTENT NEXT_SEED_CONTENT RESPONSE_FILE

set -e

NEW_CYCLE="$1"
NEW_GENERATION="$2"
PROMPT="$3"
GROWTH_MODE="$4"
NEW_METRICS_CONTENT="$5"
README_MARKER_START="$6"
README_MARKER_END="$7"
README_DYNAMIC_CONTENT="$8"
NEXT_SEED_CONTENT="$9"
RESPONSE_FILE="${10}"

cat > "$RESPONSE_FILE" <<EOF
{
  "growth_id": "$(uuidgen)",
  "new_branch": "growth/$(date +%Y%m%d-%H%M%S)-${GROWTH_MODE}-$NEW_CYCLE",
  "changes": [
    {
      "path": "evolution-metrics.json",
      "action": "replace_content",
      "content": $(echo "$NEW_METRICS_CONTENT" | jq -Rsa)
    },
    {
      "path": "README.md",
      "action": "update_readme_block",
      "marker_start": "$README_MARKER_START",
      "marker_end": "$README_MARKER_END",
      "new_block_content": $(echo "$README_DYNAMIC_CONTENT" | jq -Rsa)
    }
  ],
  "commit_message": "🌿 Growth Cycle #$NEW_CYCLE: $PROMPT",
  "next_seed_content": $(echo "$NEXT_SEED_CONTENT" | jq -Rsa)
}
EOF
