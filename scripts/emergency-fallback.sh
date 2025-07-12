#!/bin/bash
#
# @file scripts/emergency-fallback.sh
# @description Emergency fallback script for critical workflow failures
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @usage ./scripts/emergency-fallback.sh [operation] [output_file]
# @notes Ultra-minimal fallback for CI environments when all else fails
#

set -e

# Basic logging
log_info() { echo "ℹ️ [INFO] $*"; }
log_error() { echo "❌ [ERROR] $*"; }
log_success() { echo "✅ [SUCCESS] $*"; }

OPERATION="${1:-context}"
OUTPUT_FILE="${2:-/tmp/emergency_output.json}"

log_info "🚨 Emergency fallback operation: $OPERATION"

case "$OPERATION" in
  "context")
    log_info "Creating emergency context file..."
    cat > "$OUTPUT_FILE" << 'EOF'
{
  "metadata": {
    "timestamp": "TIMESTAMP_PLACEHOLDER",
    "collection_summary": {
      "files_collected": 0,
      "status": "emergency_fallback"
    }
  },
  "current_metrics": {
    "growth_cycles": 0,
    "current_generation": 0
  },
  "emergency": true
}
EOF
    # Replace timestamp
    sed -i.bak "s/TIMESTAMP_PLACEHOLDER/$(date -u +%Y-%m-%dT%H:%M:%SZ)/" "$OUTPUT_FILE" 2>/dev/null || true
    rm -f "${OUTPUT_FILE}.bak" 2>/dev/null || true
    ;;
    
  "simulation")
    log_info "Creating emergency AI response..."
    cat > "$OUTPUT_FILE" << 'EOF'
{
  "status": "emergency_fallback",
  "message": "Emergency AI response - minimal update",
  "timestamp": "TIMESTAMP_PLACEHOLDER",
  "new_branch": "evolution/emergency-BRANCH_SUFFIX",
  "changes": [
    {
      "type": "update",
      "file": "CHANGELOG.md",
      "action": "append",
      "content": "\n## Emergency Update - TIMESTAMP_PLACEHOLDER\n\n### Changed\n- Emergency evolution cycle completed\n- Minimal automated update\n"
    }
  ],
  "summary": {
    "files_modified": 1,
    "evolution_type": "emergency_fallback"
  },
  "emergency": true
}
EOF
    # Replace placeholders
    TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    BRANCH_SUFFIX=$(date +%Y%m%d-%H%M%S)
    sed -i.bak "s/TIMESTAMP_PLACEHOLDER/$TIMESTAMP/g" "$OUTPUT_FILE" 2>/dev/null || true
    sed -i.bak "s/BRANCH_SUFFIX/$BRANCH_SUFFIX/g" "$OUTPUT_FILE" 2>/dev/null || true
    rm -f "${OUTPUT_FILE}.bak" 2>/dev/null || true
    ;;
    
  *)
    log_error "Unknown operation: $OPERATION"
    exit 1
    ;;
esac

log_success "Emergency fallback completed: $OUTPUT_FILE"

# Basic validation
if command -v jq >/dev/null 2>&1; then
  if jq empty "$OUTPUT_FILE" 2>/dev/null; then
    log_success "Emergency output is valid JSON"
  else
    log_error "Emergency output is invalid JSON!"
    exit 1
  fi
else
  log_info "jq not available, skipping JSON validation"
fi
