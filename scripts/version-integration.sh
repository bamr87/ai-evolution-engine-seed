#!/bin/bash

#
# @file scripts/version-integration.sh
# @description Integration helper for version management in AI Evolution workflows
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #auto-version-management: Integrate version management with evolution workflows
#
# @relatedEvolutions
#   - v0.4.0: Version management system implementation
#
# @dependencies
#   - scripts/version-manager.sh: Main version management script
#   - git: Version control operations
#
# @changelog
#   - 2025-07-05: Initial creation for workflow integration - ITJ
#
# @usage Called by GitHub Actions and other automation scripts
# @notes Provides simple interface for version management in automated workflows
#

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source logging if available
if [[ -f "$PROJECT_ROOT/src/lib/core/logger.sh" ]]; then
    source "$PROJECT_ROOT/src/lib/core/logger.sh"
else
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; exit 1; }
    log_success() { echo "[SUCCESS] $1"; }
fi

# Configuration
VERSION_MANAGER="$SCRIPT_DIR/version-manager.sh"

# Validate version manager exists
if [[ ! -f "$VERSION_MANAGER" ]]; then
    log_error "Version manager script not found: $VERSION_MANAGER"
fi

# Function to check if version management is needed
should_manage_version() {
    local trigger_type="$1"
    
    case "$trigger_type" in
        evolution|ai-cycle|automated)
            return 0  # Always manage versions for automated processes
            ;;
        manual|user)
            # Check if files have been modified
            if git diff --quiet HEAD~1..HEAD 2>/dev/null; then
                return 1  # No changes, skip version management
            fi
            return 0
            ;;
        force)
            return 0  # Force version management
            ;;
        *)
            return 1  # Unknown trigger, skip
            ;;
    esac
}

# Function to determine version increment type based on changes
determine_increment_type() {
    local change_scope="$1"
    
    case "$change_scope" in
        breaking|major)
            echo "major"
            ;;
        feature|minor)
            echo "minor"
            ;;
        fix|patch|evolution|*)
            echo "patch"
            ;;
    esac
}

# Function to handle version management for evolution cycles
handle_evolution_version() {
    local evolution_description="$1"
    local increment_type="$2"
    
    log_info "Managing version for evolution cycle"
    log_info "Description: $evolution_description"
    log_info "Increment type: $increment_type"
    
    # Run version manager in evolution mode
    "$VERSION_MANAGER" evolution "$increment_type" "$evolution_description"
}

# Function to handle version management for manual changes
handle_manual_version() {
    local change_description="$1"
    local increment_type="$2"
    local dry_run="$3"
    
    log_info "Managing version for manual changes"
    log_info "Description: $change_description"
    log_info "Increment type: $increment_type"
    
    local args=("increment" "$increment_type" "$change_description")
    [[ "$dry_run" == "true" ]] && args+=("--dry-run")
    
    "$VERSION_MANAGER" "${args[@]}"
}

# Function to get current version
get_current_version() {
    "$VERSION_MANAGER" check-status | grep "Current Version:" | cut -d: -f2 | xargs
}

# Function to check version status
check_version_status() {
    "$VERSION_MANAGER" check-status
}

# Function to scan for files needing updates
scan_version_files() {
    "$VERSION_MANAGER" scan-files
}

# Main integration function
integrate_version_management() {
    local trigger_type="$1"
    local change_description="$2"
    local change_scope="${3:-patch}"
    local dry_run="${4:-false}"
    
    log_info "Version Integration - Trigger: $trigger_type"
    
    if ! should_manage_version "$trigger_type"; then
        log_info "Version management not needed for trigger type: $trigger_type"
        return 0
    fi
    
    local increment_type
    increment_type=$(determine_increment_type "$change_scope")
    
    case "$trigger_type" in
        evolution|ai-cycle|automated)
            handle_evolution_version "$change_description" "$increment_type"
            ;;
        manual|user|force)
            handle_manual_version "$change_description" "$increment_type" "$dry_run"
            ;;
        *)
            log_warn "Unknown trigger type: $trigger_type"
            return 1
            ;;
    esac
}

# Export functions for use by other scripts
export -f integrate_version_management
export -f get_current_version
export -f check_version_status
export -f scan_version_files

# Handle direct script execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Parse command line arguments
    case "${1:-help}" in
        integrate)
            integrate_version_management "$2" "$3" "$4" "$5"
            ;;
        version)
            get_current_version
            ;;
        status)
            check_version_status
            ;;
        scan)
            scan_version_files
            ;;
        evolution)
            integrate_version_management "evolution" "${2:-AI evolution cycle}" "patch" "${3:-false}"
            ;;
        help|--help|-h)
            cat << EOF
Version Integration Helper

Usage: $0 [command] [arguments]

Commands:
  integrate [trigger] [description] [scope] [dry_run]
    Integrate version management with specified trigger
    
  evolution [description] [dry_run]
    Handle version management for evolution cycles
    
  version
    Get current version
    
  status
    Show version status
    
  scan
    Scan files for version updates needed

Trigger Types:
  evolution    - AI evolution cycles (auto-increment patch)
  ai-cycle     - Automated AI processes
  automated    - Other automated processes
  manual       - Manual changes
  user         - User-initiated changes
  force        - Force version management

Change Scopes:
  major        - Breaking changes (increment major version)
  minor        - New features (increment minor version) 
  patch        - Bug fixes, small changes (increment patch version)

Examples:
  $0 evolution "Documentation organization"
  $0 integrate manual "Fixed bug in script" patch
  $0 integrate evolution "Added new feature" minor true
  $0 status
EOF
            ;;
        *)
            echo "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
fi
