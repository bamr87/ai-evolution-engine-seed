#!/bin/bash

#
# @file scripts/version-manager.sh
# @description Comprehensive version management system for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #auto-version-management: Implement automatic version tracking across files
#
# @relatedEvolutions
#   - v0.4.0: Version management system implementation
#
# @dependencies
#   - jq: JSON processing for configuration
#   - git: Version control and file tracking
#   - find: File system traversal
#   - sed: Text replacement
#
# @changelog
#   - 2025-07-05: Initial creation with comprehensive version management - ITJ
#
# @usage 
#   ./scripts/version-manager.sh [action] [options]
#   Actions: increment, update-all, check-status, scan-files, evolution
# @notes Handles automatic version increments and tracks file modifications
#

set -e

# Source modular libraries if available
if [[ -f "src/lib/core/logger.sh" ]]; then
    source "src/lib/core/logger.sh"
    source "src/lib/core/environment.sh"
else
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; exit 1; }
    log_success() { echo "[SUCCESS] $1"; }
fi

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_CONFIG="$PROJECT_ROOT/.version-config.json"
CHANGELOG_FILE="$PROJECT_ROOT/CHANGELOG.md"

# Default values
ACTION="${1:-check-status}"
VERSION_TYPE="${2:-patch}"
DRY_RUN=false
FORCE=false
EVOLUTION_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --evolution)
            EVOLUTION_MODE=true
            shift
            ;;
        increment|update-all|check-status|scan-files|evolution)
            ACTION="$1"
            shift
            ;;
        patch|minor|major)
            VERSION_TYPE="$1"
            shift
            ;;
        *)
            log_warn "Unknown option: $1"
            shift
            ;;
    esac
done

# Validate dependencies
check_dependencies() {
    local missing_deps=()
    
    command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
    fi
}

# Load configuration
load_config() {
    if [[ ! -f "$VERSION_CONFIG" ]]; then
        log_error "Version configuration file not found: $VERSION_CONFIG"
    fi
    
    if ! jq empty "$VERSION_CONFIG" 2>/dev/null; then
        log_error "Invalid JSON in version configuration file"
    fi
}

# Get current version
get_current_version() {
    jq -r '.current_version' "$VERSION_CONFIG"
}

# Calculate next version
calculate_next_version() {
    local current_version="$1"
    local increment_type="$2"
    
    IFS='.' read -ra version_parts <<< "$current_version"
    local major="${version_parts[0]}"
    local minor="${version_parts[1]}"
    local patch="${version_parts[2]}"
    
    case "$increment_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            log_error "Invalid version increment type: $increment_type"
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Get file hash for tracking changes
get_file_hash() {
    local file_path="$1"
    
    if [[ -f "$file_path" ]]; then
        git hash-object "$file_path" 2>/dev/null || echo "no-git"
    else
        echo "not-found"
    fi
}

# Check if file has been modified since last version
file_needs_version_update() {
    local file_path="$1"
    local last_version="$2"
    local current_version="$3"
    
    # If file doesn't exist, skip
    [[ ! -f "$file_path" ]] && return 1
    
    # If last_version equals current_version, file hasn't been updated
    [[ "$last_version" == "$current_version" ]] && return 1
    
    # Check git status for modifications
    if git rev-parse --git-dir >/dev/null 2>&1; then
        # If file has uncommitted changes or was modified in recent commits
        if git diff --name-only HEAD~1..HEAD | grep -q "$(basename "$file_path")" 2>/dev/null; then
            return 0
        fi
    fi
    
    # If we can't determine git status, assume it needs updating if versions differ
    [[ "$last_version" != "$current_version" ]] && return 0
    
    return 1
}

# Update version references in a file
update_file_version() {
    local file_path="$1"
    local new_version="$2"
    local patterns_json="$3"
    local backup_suffix=".version-backup"
    
    log_info "Updating version references in: $file_path"
    
    # Check if backup files are enabled in configuration
    local backup_enabled=$(jq -r '.change_tracking.backup_files' "$VERSION_CONFIG" 2>/dev/null)
    [[ "$backup_enabled" == "null" || -z "$backup_enabled" ]] && backup_enabled="true"
    local temp_file=""
    
    if [[ "$backup_enabled" == "true" ]]; then
        # Create backup only if enabled
        cp "$file_path" "$file_path$backup_suffix"
        log_info "  Created backup: $file_path$backup_suffix"
    else
        # Use temporary file for change verification without keeping backup
        temp_file=$(mktemp)
        cp "$file_path" "$temp_file"
        log_info "  Backup files disabled - using temporary verification"
    fi
    
    # Process each pattern
    echo "$patterns_json" | jq -c '.[]' | while read -r pattern_obj; do
        local pattern_type=$(echo "$pattern_obj" | jq -r '.type')
        local pattern=$(echo "$pattern_obj" | jq -r '.pattern')
        local line_context=$(echo "$pattern_obj" | jq -r '.line_context')
        
        log_info "  Processing pattern: $pattern_type"
        
        case "$pattern_type" in
            ascii_art)
                sed -i.tmp "s/v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\(-seed\)\{0,1\}/v$new_version-seed/g" "$file_path"
                ;;
            badge)
                sed -i.tmp "s/version-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\(--seed\)\{0,1\}/version-$new_version--seed/g" "$file_path"
                ;;
            marker_section)
                sed -i.tmp "s/Generation: [0-9][0-9]*\.[0-9][0-9]*/Generation: $new_version/g" "$file_path"
                ;;
            header_version)
                sed -i.tmp "s/Version: [0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\(-seed\)\{0,1\}/Version: $new_version-seed/g" "$file_path"
                ;;
            variable)
                sed -i.tmp "s/SEED_VERSION=\"[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\(-seed\)\{0,1\}\"/SEED_VERSION=\"$new_version-seed\"/g" "$file_path"
                ;;
            ascii_display)
                sed -i.tmp "s/v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/v$new_version/g" "$file_path"
                ;;
            workflow_name)
                sed -i.tmp "s/(v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*)/(v$new_version)/g" "$file_path"
                ;;
            header)
                sed -i.tmp "s/(v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*)/(v$new_version)/g" "$file_path"
                ;;
            summary_header)
                sed -i.tmp "s/(v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*)/(v$new_version)/g" "$file_path"
                ;;
            changelog_entry)
                sed -i.tmp "s/v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*:/v$new_version:/g" "$file_path"
                ;;
        esac
        
        # Clean up temporary file
        [[ -f "$file_path.tmp" ]] && rm "$file_path.tmp"
    done
    
    # Verify changes and handle backups based on configuration
    if [[ "$backup_enabled" == "true" ]]; then
        if diff -q "$file_path" "$file_path$backup_suffix" >/dev/null 2>&1; then
            log_warn "  No changes made to $file_path"
            rm "$file_path$backup_suffix"
        else
            log_success "  Updated $file_path (backup: $file_path$backup_suffix)"
        fi
    else
        if diff -q "$file_path" "$temp_file" >/dev/null 2>&1; then
            log_warn "  No changes made to $file_path"
        else
            log_success "  Updated $file_path (backup files disabled)"
        fi
        # Clean up temporary file
        [[ -n "$temp_file" && -f "$temp_file" ]] && rm "$temp_file"
    fi
}

# Update version configuration with new version
update_version_config() {
    local new_version="$1"
    local increment_type="$2"
    local description="$3"
    
    local temp_config=$(mktemp)
    local current_date=$(date -u +"%Y-%m-%d")
    
    # Update current version and add to history
    jq --arg version "$new_version" \
       --arg date "$current_date" \
       --arg type "$increment_type" \
       --arg desc "$description" \
       '.current_version = $version |
        .version_history += [{
          "version": $version,
          "date": $date,
          "type": $type,
          "description": $desc
        }]' "$VERSION_CONFIG" > "$temp_config"
    
    mv "$temp_config" "$VERSION_CONFIG"
    log_success "Updated version configuration to $new_version"
}

# Update CHANGELOG.md
update_changelog() {
    local new_version="$1"
    local increment_type="$2"
    local description="$3"
    
    if [[ ! -f "$CHANGELOG_FILE" ]]; then
        log_warn "CHANGELOG.md not found, skipping changelog update"
        return
    fi
    
    local current_date=$(date -u +"%Y-%m-%d")
    local temp_changelog=$(mktemp)
    
    # Create new changelog entry
    {
        head -n 7 "$CHANGELOG_FILE"  # Keep header
        echo ""
        echo "## [$new_version] - $current_date"
        echo ""
        echo "### 🔄 Version Management"
        echo "- **Version Update**: $increment_type increment ($description)"
        echo "- **Automatic File Updates**: Updated version references across tracked files"
        echo ""
        tail -n +8 "$CHANGELOG_FILE"  # Keep rest of file
    } > "$temp_changelog"
    
    mv "$temp_changelog" "$CHANGELOG_FILE"
    log_success "Updated CHANGELOG.md with version $new_version"
}

# Scan for files that need version updates
scan_files() {
    local current_version
    current_version=$(get_current_version)
    
    log_info "Scanning files for version update requirements..."
    log_info "Current version: $current_version"
    
    # Get tracked files from config
    local tracked_files
    tracked_files=$(jq -r '.tracked_files | to_entries[] | .value[]' "$VERSION_CONFIG")
    
    echo "$tracked_files" | jq -c '.' | while read -r file_config; do
        local file_path=$(echo "$file_config" | jq -r '.path')
        local last_modified_version=$(echo "$file_config" | jq -r '.last_modified_version')
        
        # Handle wildcard paths
        if [[ "$file_path" == *"*"* ]]; then
            find "$PROJECT_ROOT" -name "$(basename "$file_path")" -type f | while read -r actual_file; do
                local rel_path=${actual_file#$PROJECT_ROOT/}
                if file_needs_version_update "$actual_file" "$last_modified_version" "$current_version"; then
                    echo "NEEDS_UPDATE: $rel_path (last: $last_modified_version, current: $current_version)"
                else
                    echo "UP_TO_DATE: $rel_path (version: $last_modified_version)"
                fi
            done
        else
            local full_path="$PROJECT_ROOT/$file_path"
            if file_needs_version_update "$full_path" "$last_modified_version" "$current_version"; then
                echo "NEEDS_UPDATE: $file_path (last: $last_modified_version, current: $current_version)"
            else
                echo "UP_TO_DATE: $file_path (version: $last_modified_version)"
            fi
        fi
    done
}

# Update all tracked files with new version
update_all_files() {
    local new_version="$1"
    
    log_info "Updating version references in all tracked files to: $new_version"
    
    # Process each file category
    for category in core_files documentation_files script_files; do
        log_info "Processing $category..."
        
        jq -c ".tracked_files.$category[]" "$VERSION_CONFIG" | while read -r file_config; do
            local file_path=$(echo "$file_config" | jq -r '.path')
            local patterns=$(echo "$file_config" | jq -c '.patterns')
            
            # Handle wildcard paths
            if [[ "$file_path" == *"*"* ]]; then
                find "$PROJECT_ROOT" -name "$(basename "$file_path")" -type f | while read -r actual_file; do
                    [[ "$DRY_RUN" == true ]] && log_info "DRY RUN: Would update $actual_file" || update_file_version "$actual_file" "$new_version" "$patterns"
                done
            else
                local full_path="$PROJECT_ROOT/$file_path"
                if [[ -f "$full_path" ]]; then
                    [[ "$DRY_RUN" == true ]] && log_info "DRY RUN: Would update $full_path" || update_file_version "$full_path" "$new_version" "$patterns"
                fi
            fi
        done
    done
}

# Mark files as updated to current version in config
mark_files_updated() {
    local new_version="$1"
    local temp_config=$(mktemp)
    
    # Update last_modified_version for all tracked files
    jq --arg version "$new_version" '
        .tracked_files.core_files |= map(.last_modified_version = $version) |
        .tracked_files.documentation_files |= map(.last_modified_version = $version) |
        .tracked_files.script_files |= map(.last_modified_version = $version)
    ' "$VERSION_CONFIG" > "$temp_config"
    
    mv "$temp_config" "$VERSION_CONFIG"
    log_success "Marked all files as updated to version $new_version"
}

# Main action handlers
action_increment() {
    local current_version
    local new_version
    local description="${3:-Automatic version increment}"
    
    current_version=$(get_current_version)
    new_version=$(calculate_next_version "$current_version" "$VERSION_TYPE")
    
    log_info "Version increment: $current_version → $new_version ($VERSION_TYPE)"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN: Would increment version and update files"
        return 0
    fi
    
    # Initialize change tracking if tracker script exists
    if [[ -f "$PROJECT_ROOT/scripts/version-tracker.sh" ]]; then
        log_info "Initializing change tracking for version increment"
        "$PROJECT_ROOT/scripts/version-tracker.sh" track-change --action "pre-version-update" --version "$current_version"
    fi
    
    # Update all files
    update_all_files "$new_version"
    
    # Update configuration and changelog
    update_version_config "$new_version" "$VERSION_TYPE" "$description"
    update_changelog "$new_version" "$VERSION_TYPE" "$description"
    
    # Mark files as updated
    mark_files_updated "$new_version"
    
    # Track the version change and correlate files if tracker script exists
    if [[ -f "$PROJECT_ROOT/scripts/version-tracker.sh" ]]; then
        log_info "Tracking version change and correlating files"
        "$PROJECT_ROOT/scripts/version-tracker.sh" track-change --action "post-version-update" --version "$new_version"
        "$PROJECT_ROOT/scripts/version-tracker.sh" correlate-files --old-version "$current_version" --new-version "$new_version"
        
        # Update changelog with file correlations
        "$PROJECT_ROOT/scripts/version-tracker.sh" update-changelog --version "$new_version" --prompt "$description"
        
        log_info "Generated correlation report for version $new_version"
    fi
    
    log_success "Version increment complete: $new_version"
}

action_update_all() {
    local current_version
    current_version=$(get_current_version)
    
    log_info "Updating all files to current version: $current_version"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN: Would update all files to current version"
        return 0
    fi
    
    update_all_files "$current_version"
    mark_files_updated "$current_version"
    
    log_success "All files updated to version $current_version"
}

action_check_status() {
    local current_version
    current_version=$(get_current_version)
    
    log_info "Version Management Status"
    echo "=========================="
    echo "Current Version: $current_version"
    echo "Configuration: $VERSION_CONFIG"
    echo "Changelog: $CHANGELOG_FILE"
    echo ""
    
    scan_files
}

action_evolution() {
    local description="${3:-AI evolution cycle}"
    
    log_info "Evolution mode: automatic version management for AI evolution"
    
    # For evolution cycles, we typically do patch increments
    VERSION_TYPE="patch"
    action_increment "$VERSION_TYPE" "$description"
}

# Main execution
main() {
    log_info "AI Evolution Engine Version Manager v1.0.0"
    log_info "Action: $ACTION, Type: $VERSION_TYPE, Dry Run: $DRY_RUN"
    
    check_dependencies
    load_config
    
    case "$ACTION" in
        increment)
            action_increment
            ;;
        update-all)
            action_update_all
            ;;
        check-status)
            action_check_status
            ;;
        scan-files)
            scan_files
            ;;
        evolution)
            action_evolution
            ;;
        *)
            log_error "Unknown action: $ACTION"
            ;;
    esac
}

# Show usage if --help
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    cat << EOF
AI Evolution Engine Version Manager

Usage: $0 [action] [type] [options]

Actions:
  increment     Increment version and update all files
  update-all    Update all files to current version
  check-status  Show current version status
  scan-files    Scan for files needing updates
  evolution     Special mode for AI evolution cycles

Version Types (for increment):
  patch         Increment patch version (default)
  minor         Increment minor version
  major         Increment major version

Options:
  --dry-run     Show what would be done without making changes
  --force       Force update even if files appear unchanged
  --evolution   Use evolution-specific settings

Examples:
  $0 check-status
  $0 increment patch --dry-run
  $0 evolution
  $0 update-all
EOF
    exit 0
fi

# Run main function
main "$@"
