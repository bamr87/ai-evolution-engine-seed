#!/bin/bash
#
# @file scripts/simple-ai-simulator.sh
# @description Simple AI growth simulator for CI environments
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @usage ./scripts/simple-ai-simulator.sh [output_file]
# @notes Minimal AI simulation without complex dependencies
#

set -euo pipefail

# Simple logging functions
log_info() { echo "ℹ️ [INFO] $*"; }
log_warn() { echo "⚠️ [WARN] $*"; }
log_error() { echo "❌ [ERROR] $*"; }
log_success() { echo "✅ [SUCCESS] $*"; }

# Set output file
OUTPUT_FILE="${1:-/tmp/evolution_response.json}"
PROMPT="${2:-Analyze recent commits and update CHANGELOG.md with proper semantic versioning.}"
GROWTH_MODE="${3:-adaptive}"

log_info "🤖 Simple AI simulation starting..."

# Get current git information
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Create a new branch name
NEW_BRANCH="evolution/simple-update-$(date +%Y%m%d-%H%M%S)"

# Create basic AI response
cat > "$OUTPUT_FILE" << EOF
{
  "status": "simple_simulation_complete",
  "simulation_type": "simple",
  "timestamp": "$TIMESTAMP",
  "prompt": "$PROMPT",
  "growth_mode": "$GROWTH_MODE",
  "base_commit": "$GIT_COMMIT",
  "base_branch": "$GIT_BRANCH",
  "new_branch": "$NEW_BRANCH",
  "changes": [
    {
      "type": "update",
      "file": "CHANGELOG.md",
      "action": "append",
      "content": "\\n## [Unreleased] - $TIMESTAMP\\n\\n### Changed\\n- Automated evolution cycle completed\\n- Repository context analyzed and updated\\n- Growth mode: $GROWTH_MODE\\n"
    },
    {
      "type": "update", 
      "file": "evolution-metrics.json",
      "action": "update_json",
      "content": {
        "last_evolution": "$TIMESTAMP",
        "growth_mode": "$GROWTH_MODE",
        "evolution_count": "increment"
      }
    }
  ],
  "summary": {
    "files_modified": 2,
    "evolution_type": "simple_update",
    "description": "Simple automated evolution cycle focusing on changelog and metrics updates"
  },
  "metadata": {
    "simulator": "simple-ai-simulator",
    "version": "1.0.0",
    "ci_environment": true
  }
}
EOF

log_success "Simple AI simulation completed successfully"
log_info "Output file: $OUTPUT_FILE"
log_info "New branch: $NEW_BRANCH"

# Validate output
if jq empty "$OUTPUT_FILE" 2>/dev/null; then
  log_success "Output JSON is valid"
else
  log_error "Output JSON is invalid!"
  exit 1
fi
