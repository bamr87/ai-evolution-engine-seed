#!/bin/bash
# scripts/apply-growth-changes.sh
# Applies evolutionary changes from AI response

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/evolution/git.sh"

RESPONSE_FILE="${1:-/tmp/evolution_response.json}"

log_info "Applying evolutionary changes..."

if [ ! -f "$RESPONSE_FILE" ]; then
    log_error "Response file not found: $RESPONSE_FILE"
    exit 1
fi

BRANCH_NAME=$(jq -r .new_branch "$RESPONSE_FILE")

log_info "Creating and switching to new branch: $BRANCH_NAME"
create_branch "$BRANCH_NAME"

# Apply file changes from AI response
log_info "Applying file changes..."
jq -c '.changes[]' "$RESPONSE_FILE" | while read -r change_json; do
  path=$(echo "$change_json" | jq -r '.path')
  action=$(echo "$change_json" | jq -r '.action')
  
  mkdir -p "$(dirname "$path")"
  log_info "Processing change for $path (Action: $action)"

  if [ "$action" == "replace_content" ]; then
    content=$(echo "$change_json" | jq -r '.content')
    echo -e "$content" > "$path"
    log_success "Content replaced for $path"
  elif [ "$action" == "create" ]; then
    content=$(echo "$change_json" | jq -r '.content')
    echo -e "$content" > "$path"
    log_success "File created: $path"
  elif [ "$action" == "update_readme_block" ]; then
    # More robust way to handle multiline content for sed
    new_block_content_escaped_for_sed=$(echo "$change_json" | jq -r '.new_block_content')
    
    # Use awk for safer multiline replacement between markers
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
