#!/usr/bin/env bash
# scripts/generate_ai_response.sh
# Usage: generate_ai_response.sh NEW_CYCLE NEW_GENERATION PROMPT GROWTH_MODE NEW_METRICS_CONTENT README_MARKER_START README_MARKER_END README_DYNAMIC_CONTENT NEXT_SEED_CONTENT RESPONSE_FILE

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Source modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"

# Initialize logging
init_logger "logs" "generate-ai-response"

# Validate input parameters
if [[ $# -lt 10 ]]; then
    log_error "Usage: $0 <new_cycle> <new_generation> <prompt> <growth_mode> <new_metrics_content> <readme_marker_start> <readme_marker_end> <readme_dynamic_content> <next_seed_content> <response_file>"
    exit 1
fi

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

log_info "Generating AI response for cycle $NEW_CYCLE, generation $NEW_GENERATION"
log_info "Output file: $RESPONSE_FILE"

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

log_success "AI response JSON generated successfully: $RESPONSE_FILE"
