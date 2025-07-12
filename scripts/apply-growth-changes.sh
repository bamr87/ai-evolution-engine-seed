#!/bin/bash
#
# @file scripts/apply-growth-changes.sh
# @description Applies evolutionary changes from AI response using modular architecture
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-07
# @version 2.0.0
#
# @relatedIssues 
#   - Modular refactoring: Migrate to modular architecture
#   - Change application: Enhanced change processing
#
# @relatedEvolutions
#   - v2.0.0: Migrated to modular architecture with enhanced change application
#   - v1.0.0: Original implementation
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - ../src/lib/evolution/git.sh: Git operations module
#   - ../src/lib/utils/json_processor.sh: JSON processing utilities
#   - ../src/lib/utils/file_operations.sh: File operation utilities
#
# @changelog
#   - 2025-07-07: Migrated to modular architecture - ITJ
#   - 2025-07-05: Enhanced change application logic - ITJ
#
# @usage ./scripts/apply-growth-changes.sh <response_file>
# @notes Applies evolutionary changes with robust error handling
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
bootstrap_library

# Load required modules
require_module "core/logger"
require_module "core/environment"
require_module "core/validation"
require_module "evolution/git"
require_module "utils/json_processor"
require_module "utils/file_operations"

# Initialize logging
init_logger "logs" "apply-growth-changes"

# Parse command line arguments
RESPONSE_FILE=""
GROWTH_MODE=""
CI_MODE="false"

while [[ $# -gt 0 ]]; do
    case $1 in
        --growth-mode)
            GROWTH_MODE="$2"
            shift 2
            ;;
        --response-file)
            RESPONSE_FILE="$2"
            shift 2
            ;;
        --ci-mode)
            CI_MODE="true"
            shift
            ;;
        *)
            if [[ -z "$RESPONSE_FILE" ]]; then
                RESPONSE_FILE="$1"
            fi
            shift
            ;;
    esac
done

# Set defaults
RESPONSE_FILE="${RESPONSE_FILE:-/tmp/evolution_response.json}"
GROWTH_MODE="${GROWTH_MODE:-adaptive}"

validate_required "RESPONSE_FILE" "$RESPONSE_FILE"
validate_file_readable "$RESPONSE_FILE"

log_info "Applying evolutionary changes..."

BRANCH_NAME=$(json_get_value "$(cat "$RESPONSE_FILE")" ".new_branch" "")

if [[ -z "$BRANCH_NAME" ]]; then
    log_error "No branch name found in response file"
    exit 1
fi

log_info "Creating and switching to new branch: $BRANCH_NAME"
create_branch "$BRANCH_NAME"

# Apply file changes from AI response
log_info "Applying file changes..."
CHANGES_JSON=$(json_get_value "$(cat "$RESPONSE_FILE")" ".changes" "[]")

# Process each change
echo "$CHANGES_JSON" | jq -c '.[]' | while read -r change_json; do
  path=$(json_get_value "$change_json" ".path" "")
  action=$(json_get_value "$change_json" ".action" "")
  
  if [[ -z "$path" || -z "$action" ]]; then
    log_error "Invalid change entry: missing path or action"
    continue
  fi
  
  ensure_directory "$(dirname "$path")"
  log_info "Processing change for $path (Action: $action)"

  case "$action" in
    "replace_content"|"create")
      content=$(json_get_value "$change_json" ".content" "")
      echo -e "$content" > "$path"
      log_success "Content ${action} for $path"
      ;;
    "update_readme_block")
      # Use modular file operations for safer multiline replacement
      start_marker=$(json_get_value "$change_json" ".start_marker" "")
      end_marker=$(json_get_value "$change_json" ".end_marker" "")
      new_content=$(json_get_value "$change_json" ".new_block_content" "")
      
      if [[ -n "$start_marker" && -n "$end_marker" && -n "$new_content" ]]; then
        if file_replace_between_markers "$path" "$start_marker" "$end_marker" "$new_content"; then
          log_success "README block updated in $path"
        else
          log_error "Failed to update README block in $path"
        fi
      else
        log_error "Missing markers or content for README block update"
      fi
      ;;
    *)
      log_error "Unknown action: $action"
      ;;
  esac
done
    awk -v start="<!-- AI-EVOLUTION-MARKER:START -->" \
        -v end="<!-- AI-EVOLUTION-MARKER:END -->" \
        -v new_content="$new_block_content_escaped_for_sed" '
    BEGIN { p = 1 }
    $0 == start { print; print new_content; p = 0; next }
    $0 == end { p = 1 }
    p { print }
    ' "$path" > "${path}.tmp" && mv "${path}.tmp" "$path"
    log_success "README.md block updated for $path"
  else
    log_warn "Unknown action: $action for $path"
  fi
done

# Commit growth
log_info "Committing changes..."
git add -A

COMMIT_MSG=$(jq -r .commit_message "$RESPONSE_FILE")
if commit_changes "$COMMIT_MSG"; then
    log_success "Changes committed successfully"
    push_branch "$BRANCH_NAME"
    log_success "Changes pushed to branch: $BRANCH_NAME"
else
    log_warn "No changes to commit, or commit failed"
fi
