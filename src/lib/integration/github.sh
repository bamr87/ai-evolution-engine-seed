#!/bin/bash
#
# @file src/lib/integration/github.sh
# @description GitHub API and workflow integration module
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular GitHub integration
#
# @dependencies
#   - bash: >=4.0
#   - gh: GitHub CLI
#   - jq: JSON processor
#   - core/logger.sh: Logging functions
#   - core/utils.sh: Utility functions
#
# @changelog
#   - 2025-07-05: Initial creation of GitHub integration module - ITJ
#
# @usage require_module "integration/github"; github_create_pr
# @notes Handles all GitHub API interactions and workflow operations
#

# Prevent multiple imports
[[ "${__GITHUB_MODULE_LOADED:-}" == "true" ]] && return 0
readonly __GITHUB_MODULE_LOADED=true

# Source dependencies if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! declare -F log_info >/dev/null 2>&1; then
    source "$SCRIPT_DIR/../core/logger.sh"
fi

readonly GITHUB_MODULE_VERSION="2.0.0"

# GitHub integration state
GITHUB_REPO=""
GITHUB_OWNER=""
GITHUB_TOKEN=""
GITHUB_CLI_AVAILABLE=false

# Initialize GitHub integration
# Args:
#   $1: repo (optional) - format: owner/repo
# Returns:
#   0: success
#   1: failure
github_init() {
    local repo="${1:-}"
    
    log_info "Initializing GitHub integration v$GITHUB_MODULE_VERSION"
    
    # Check GitHub CLI availability
    if command -v gh >/dev/null 2>&1; then
        GITHUB_CLI_AVAILABLE=true
        log_debug "GitHub CLI is available"
    else
        log_warn "GitHub CLI not found, some features will be limited"
        GITHUB_CLI_AVAILABLE=false
    fi
    
    # Set repository info
    if [[ -n "$repo" ]]; then
        GITHUB_OWNER="${repo%/*}"
        GITHUB_REPO="${repo#*/}"
        log_debug "GitHub repo set to: $GITHUB_OWNER/$GITHUB_REPO"
    elif [[ "$GITHUB_CLI_AVAILABLE" == "true" ]]; then
        # Try to detect from current repository
        local repo_info
        if repo_info=$(gh repo view --json owner,name 2>/dev/null); then
            GITHUB_OWNER=$(echo "$repo_info" | jq -r '.owner.login')
            GITHUB_REPO=$(echo "$repo_info" | jq -r '.name')
            log_debug "Auto-detected GitHub repo: $GITHUB_OWNER/$GITHUB_REPO"
        fi
    fi
    
    return 0
}

# Check if GitHub CLI is authenticated
# Returns:
#   0: authenticated
#   1: not authenticated
github_check_auth() {
    if [[ "$GITHUB_CLI_AVAILABLE" != "true" ]]; then
        log_error "GitHub CLI is not available"
        return 1
    fi
    
    if gh auth status >/dev/null 2>&1; then
        log_debug "GitHub CLI is authenticated"
        return 0
    else
        log_error "GitHub CLI is not authenticated. Run 'gh auth login'"
        return 1
    fi
}

# Create a pull request
# Args:
#   $1: title
#   $2: body
#   $3: base_branch (optional, default: main)
#   $4: head_branch (optional, default: current branch)
# Returns:
#   0: success
#   1: failure
github_create_pr() {
    local title="$1"
    local body="$2"
    local base_branch="${3:-main}"
    local head_branch="${4:-}"
    
    if [[ -z "$title" ]]; then
        log_error "PR title is required"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    # Get current branch if not specified
    if [[ -z "$head_branch" ]]; then
        head_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || {
            log_error "Failed to get current branch"
            return 1
        }
    fi
    
    log_info "Creating PR: $title"
    log_debug "From: $head_branch -> $base_branch"
    
    # Create PR using GitHub CLI
    local pr_url
    if pr_url=$(gh pr create \
        --title "$title" \
        --body "$body" \
        --base "$base_branch" \
        --head "$head_branch" \
        2>/dev/null); then
        log_info "Pull request created: $pr_url"
        echo "$pr_url"
        return 0
    else
        log_error "Failed to create pull request"
        return 1
    fi
}

# Update pull request
# Args:
#   $1: pr_number
#   $2: title (optional)
#   $3: body (optional)
# Returns:
#   0: success
#   1: failure
github_update_pr() {
    local pr_number="$1"
    local title="${2:-}"
    local body="${3:-}"
    
    if [[ -z "$pr_number" ]]; then
        log_error "PR number is required"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    local args=()
    
    if [[ -n "$title" ]]; then
        args+=(--title "$title")
    fi
    
    if [[ -n "$body" ]]; then
        args+=(--body "$body")
    fi
    
    if [[ ${#args[@]} -eq 0 ]]; then
        log_warn "No updates specified for PR #$pr_number"
        return 0
    fi
    
    log_info "Updating PR #$pr_number"
    
    if gh pr edit "$pr_number" "${args[@]}" >/dev/null 2>&1; then
        log_info "Pull request #$pr_number updated successfully"
        return 0
    else
        log_error "Failed to update pull request #$pr_number"
        return 1
    fi
}

# Get pull request status
# Args:
#   $1: pr_number
# Returns:
#   0: success (prints status)
#   1: failure
github_get_pr_status() {
    local pr_number="$1"
    
    if [[ -z "$pr_number" ]]; then
        log_error "PR number is required"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    local pr_info
    if pr_info=$(gh pr view "$pr_number" --json state,mergeable,statusCheckRollupState 2>/dev/null); then
        echo "$pr_info"
        return 0
    else
        log_error "Failed to get PR #$pr_number status"
        return 1
    fi
}

# Merge pull request
# Args:
#   $1: pr_number
#   $2: merge_method (optional: merge, squash, rebase)
# Returns:
#   0: success
#   1: failure
github_merge_pr() {
    local pr_number="$1"
    local merge_method="${2:-merge}"
    
    if [[ -z "$pr_number" ]]; then
        log_error "PR number is required"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    case "$merge_method" in
        merge|squash|rebase)
            ;;
        *)
            log_error "Invalid merge method: $merge_method"
            return 1
            ;;
    esac
    
    log_info "Merging PR #$pr_number using $merge_method"
    
    if gh pr merge "$pr_number" --"$merge_method" >/dev/null 2>&1; then
        log_info "Pull request #$pr_number merged successfully"
        return 0
    else
        log_error "Failed to merge pull request #$pr_number"
        return 1
    fi
}

# Create a GitHub release
# Args:
#   $1: tag
#   $2: title
#   $3: notes (optional)
#   $4: prerelease (optional: true/false)
# Returns:
#   0: success
#   1: failure
github_create_release() {
    local tag="$1"
    local title="$2"
    local notes="${3:-}"
    local prerelease="${4:-false}"
    
    if [[ -z "$tag" || -z "$title" ]]; then
        log_error "Tag and title are required for release"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    log_info "Creating release: $tag"
    
    local args=(
        --tag "$tag"
        --title "$title"
    )
    
    if [[ -n "$notes" ]]; then
        args+=(--notes "$notes")
    fi
    
    if [[ "$prerelease" == "true" ]]; then
        args+=(--prerelease)
    fi
    
    local release_url
    if release_url=$(gh release create "${args[@]}" 2>/dev/null); then
        log_info "Release created: $release_url"
        echo "$release_url"
        return 0
    else
        log_error "Failed to create release"
        return 1
    fi
}

# Trigger a workflow
# Args:
#   $1: workflow_name
#   $2: ref (optional, default: main)
#   $3: inputs (optional JSON object)
# Returns:
#   0: success
#   1: failure
github_trigger_workflow() {
    local workflow_name="$1"
    local ref="${2:-main}"
    local inputs="${3:-}"
    
    if [[ -z "$workflow_name" ]]; then
        log_error "Workflow name is required"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    log_info "Triggering workflow: $workflow_name"
    log_debug "Ref: $ref"
    
    local args=(
        --ref "$ref"
    )
    
    if [[ -n "$inputs" ]]; then
        # Parse inputs and add them as key=value pairs
        while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                args+=(--field "$line")
            fi
        done < <(echo "$inputs" | jq -r 'to_entries[] | "\(.key)=\(.value)"' 2>/dev/null || echo "")
    fi
    
    if gh workflow run "$workflow_name" "${args[@]}" >/dev/null 2>&1; then
        log_info "Workflow triggered successfully"
        return 0
    else
        log_error "Failed to trigger workflow"
        return 1
    fi
}

# Get workflow run status
# Args:
#   $1: run_id
# Returns:
#   0: success (prints status)
#   1: failure
github_get_workflow_status() {
    local run_id="$1"
    
    if [[ -z "$run_id" ]]; then
        log_error "Workflow run ID is required"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    local run_info
    if run_info=$(gh run view "$run_id" --json status,conclusion,workflowName 2>/dev/null); then
        echo "$run_info"
        return 0
    else
        log_error "Failed to get workflow run status"
        return 1
    fi
}

# Create an issue
# Args:
#   $1: title
#   $2: body
#   $3: labels (optional, comma-separated)
#   $4: assignees (optional, comma-separated)
# Returns:
#   0: success
#   1: failure
github_create_issue() {
    local title="$1"
    local body="$2"
    local labels="${3:-}"
    local assignees="${4:-}"
    
    if [[ -z "$title" ]]; then
        log_error "Issue title is required"
        return 1
    fi
    
    if ! github_check_auth; then
        return 1
    fi
    
    log_info "Creating issue: $title"
    
    local args=(
        --title "$title"
        --body "$body"
    )
    
    if [[ -n "$labels" ]]; then
        args+=(--label "$labels")
    fi
    
    if [[ -n "$assignees" ]]; then
        args+=(--assignee "$assignees")
    fi
    
    local issue_url
    if issue_url=$(gh issue create "${args[@]}" 2>/dev/null); then
        log_info "Issue created: $issue_url"
        echo "$issue_url"
        return 0
    else
        log_error "Failed to create issue"
        return 1
    fi
}

# Generate PR body from evolution context
# Args:
#   $1: evolution_type
#   $2: intensity
#   $3: growth_mode
#   $4: prompt
#   $5: changes_summary (optional)
# Returns:
#   0: success (prints PR body)
github_generate_pr_body() {
    local evolution_type="$1"
    local intensity="$2"
    local growth_mode="$3"
    local prompt="$4"
    local changes_summary="${5:-}"
    
    cat << EOF
# 🌱 AI Evolution Engine - Growth Cycle

## Evolution Details
- **Type**: $evolution_type
- **Intensity**: $intensity
- **Growth Mode**: $growth_mode
- **Prompt**: $prompt

## Changes Summary
$changes_summary

## Evolution Context
This pull request represents an automated evolution cycle in the AI Evolution Engine. The changes have been generated based on the specified evolution parameters and are designed to improve the repository's functionality, maintainability, and growth potential.

## Review Guidelines
- Review changes for alignment with evolution objectives
- Ensure all tests pass and quality checks are satisfied
- Verify that the evolution maintains backward compatibility where applicable
- Check that documentation reflects any significant changes

## Next Steps
After this PR is merged, the evolution cycle will be considered complete, and metrics will be updated to reflect the growth achieved.

---
*Generated by AI Evolution Engine v2.0.0*
EOF
}

log_debug "GitHub integration module loaded (v$GITHUB_MODULE_VERSION)"
