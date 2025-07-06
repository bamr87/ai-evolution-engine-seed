#!/usr/bin/env bash
#
# @file scripts/create_pr.sh
# @description Creates a pull request with evolution changes using modular library
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular refactor using new library system
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/bootstrap.sh: Library bootstrap
#   - src/lib/integration/github.sh: GitHub integration
#
# @changelog
#   - 2025-07-05: Refactored to use modular library system - ITJ
#
# @usage ./create_pr.sh <response_file> <prompt> <growth_mode>
# @notes Creates evolution PR using GitHub integration module
#

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Bootstrap the modular library system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
bootstrap_library

# Load required modules
require_module "core/logger"
require_module "core/validation"
require_module "integration/github"
require_module "evolution/git"

# Initialize logging
init_logger "logs" "create-pr"

# Validate input parameters
if [[ $# -lt 3 ]]; then
    log_error "Usage: $0 <response_file> <prompt> <growth_mode>"
    exit 1
fi

RESPONSE_FILE="$1"
PROMPT="$2"
GROWTH_MODE="$3"

log_info "Creating pull request for evolution changes"
log_info "Response file: $RESPONSE_FILE"
log_info "Growth mode: $GROWTH_MODE"

# Validate inputs using modular validation
if ! validate_file_exists "$RESPONSE_FILE"; then
    log_error "Response file not found: $RESPONSE_FILE"
    exit 1
fi

# Initialize GitHub integration
github_init || {
    log_error "Failed to initialize GitHub integration"
    exit 1
}

log_info "🌳 Creating growth pull request..."

# Extract data from response file using jq
if ! command -v jq >/dev/null 2>&1; then
    log_error "jq is required for JSON processing"
    exit 1
fi

BRANCH_NAME=$(jq -r '.new_branch // empty' "$RESPONSE_FILE" 2>/dev/null)
COMMIT_MSG=$(jq -r '.commit_message // empty' "$RESPONSE_FILE" 2>/dev/null)
EVOLUTION_TYPE=$(jq -r '.evolution_type // "evolution"' "$RESPONSE_FILE" 2>/dev/null)
INTENSITY=$(jq -r '.intensity // "minimal"' "$RESPONSE_FILE" 2>/dev/null)

# Validate extracted data
if [[ -z "$BRANCH_NAME" ]]; then
    log_error "Could not extract branch name from response file"
    exit 1
fi

if [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="🌱 AI Evolution: $EVOLUTION_TYPE ($INTENSITY)"
    log_warn "No commit message found, using default: $COMMIT_MSG"
fi

# Generate PR body using GitHub integration module
PR_TITLE="🌱 AI Evolution Cycle: $EVOLUTION_TYPE"
PR_BODY=$(github_generate_pr_body "$EVOLUTION_TYPE" "$INTENSITY" "$GROWTH_MODE" "$PROMPT")

log_info "Creating pull request with title: $PR_TITLE"

# Create the pull request
if github_create_pr "$PR_TITLE" "$PR_BODY" "main" "$BRANCH_NAME"; then
    log_success "✅ Pull request created successfully"
else
    log_error "❌ Failed to create pull request"
    exit 1
fi
