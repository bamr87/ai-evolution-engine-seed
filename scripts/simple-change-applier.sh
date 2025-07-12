#!/bin/bash
#
# @file scripts/simple-change-applier.sh
# @description Simple change application script for CI environments
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @usage ./scripts/simple-change-applier.sh [response_file]
# @notes Minimal change application without complex dependencies
#

set -euo pipefail

# Simple logging functions
log_info() { echo "ℹ️ [INFO] $*"; }
log_warn() { echo "⚠️ [WARN] $*"; }
log_error() { echo "❌ [ERROR] $*"; }
log_success() { echo "✅ [SUCCESS] $*"; }

# Set response file
RESPONSE_FILE="${1:-/tmp/evolution_response.json}"

log_info "🔧 Simple change application starting..."

# Validate response file exists
if [[ ! -f "$RESPONSE_FILE" ]]; then
  log_error "Response file not found: $RESPONSE_FILE"
  exit 1
fi

# Validate JSON
if ! jq empty "$RESPONSE_FILE" 2>/dev/null; then
  log_error "Invalid JSON in response file"
  exit 1
fi

# Get branch name
NEW_BRANCH=$(jq -r '.new_branch // empty' "$RESPONSE_FILE")
if [[ -z "$NEW_BRANCH" ]]; then
  log_warn "No new branch specified, using default"
  NEW_BRANCH="evolution/simple-changes-$(date +%Y%m%d-%H%M%S)"
fi

log_info "Creating and switching to branch: $NEW_BRANCH"

# Create new branch
git checkout -b "$NEW_BRANCH" 2>/dev/null || {
  log_warn "Branch may already exist, switching to it"
  git checkout "$NEW_BRANCH" 2>/dev/null || {
    log_error "Failed to create or switch to branch"
    exit 1
  }
}

# Process changes
CHANGES_COUNT=$(jq '.changes | length' "$RESPONSE_FILE" 2>/dev/null || echo "0")
log_info "Processing $CHANGES_COUNT changes..."

if [[ "$CHANGES_COUNT" -gt 0 ]]; then
  # Process each change
  for i in $(seq 0 $((CHANGES_COUNT-1))); do
    CHANGE=$(jq -r ".changes[$i]" "$RESPONSE_FILE")
    FILE_PATH=$(echo "$CHANGE" | jq -r '.file')
    ACTION=$(echo "$CHANGE" | jq -r '.action // "update"')
    CONTENT=$(echo "$CHANGE" | jq -r '.content // ""')
    
    log_info "Processing change $((i+1))/$CHANGES_COUNT: $FILE_PATH ($ACTION)"
    
    case "$ACTION" in
      "append")
        if [[ -n "$CONTENT" ]]; then
          echo -e "$CONTENT" >> "$FILE_PATH"
          log_success "Appended content to $FILE_PATH"
        fi
        ;;
      "create")
        if [[ -n "$CONTENT" ]]; then
          # Create directory if needed
          mkdir -p "$(dirname "$FILE_PATH")"
          echo -e "$CONTENT" > "$FILE_PATH"
          log_success "Created file $FILE_PATH"
        fi
        ;;
      "update"|*)
        if [[ -n "$CONTENT" ]]; then
          # For CHANGELOG.md, append instead of overwrite
          if [[ "$FILE_PATH" == "CHANGELOG.md" && -f "$FILE_PATH" ]]; then
            echo -e "$CONTENT" >> "$FILE_PATH"
            log_success "Updated $FILE_PATH (appended)"
          else
            echo -e "$CONTENT" > "$FILE_PATH"
            log_success "Updated $FILE_PATH"
          fi
        fi
        ;;
    esac
  done
else
  log_info "No changes to apply, creating minimal update"
  
  # Create a simple changelog entry
  if [[ -f "CHANGELOG.md" ]]; then
    echo "" >> CHANGELOG.md
    echo "## [Unreleased] - $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    echo "### Changed" >> CHANGELOG.md
    echo "- Automated evolution cycle completed" >> CHANGELOG.md
    echo "- Simple change application used" >> CHANGELOG.md
    log_success "Updated CHANGELOG.md"
  fi
fi

# Update evolution metrics if file exists
if [[ -f "evolution-metrics.json" ]]; then
  # Simple metrics update
  CURRENT_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  jq --arg timestamp "$CURRENT_TIME" \
     '.last_evolution = $timestamp | 
      .evolution_count = (.evolution_count // 0) + 1 |
      .last_change_applier = "simple-change-applier"' \
     evolution-metrics.json > evolution-metrics.json.tmp && \
     mv evolution-metrics.json.tmp evolution-metrics.json
  log_success "Updated evolution metrics"
fi

# Commit changes
log_info "Committing changes..."
git add -A
if git commit -m "🤖 Simple evolution cycle

Applied changes via simple-change-applier
Branch: $NEW_BRANCH
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"; then
  log_success "Changes committed successfully"
else
  log_warn "No changes to commit or commit failed"
fi

log_success "Simple change application completed"
log_info "Branch: $NEW_BRANCH"
