#!/bin/bash

#
# @file scripts/version-tracker.sh
# @description Advanced version change tracking and file correlation system
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #enhanced-version-tracking: Comprehensive change tracking without backups
#
# @relatedEvolutions
#   - v0.4.0: Enhanced version management with change correlation
#
# @dependencies
#   - jq: JSON processing for change tracking
#   - git: Version control integration
#   - shasum: File hash generation
#
# @changelog
#   - 2025-07-05: Initial creation with change tracking capabilities - ITJ
#
# @usage 
#   ./scripts/version-tracker.sh [action] [options]
#   Actions: track-change, correlate-files, generate-report, show-history
# @notes Tracks file changes and correlates them with version increments
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
VERSION_CONFIG="$PROJECT_ROOT/config/.version-config.json"
CHANGE_LOG_FILE="$PROJECT_ROOT/version-changes.json"
CHANGELOG_FILE="$PROJECT_ROOT/CHANGELOG.md"

# Default values
ACTION=""
TRACK_ACTION=""
VERSION=""
OLD_VERSION=""
NEW_VERSION=""
PROMPT=""
FORMAT="markdown"
OUTPUT_FILE=""
LIMIT=10
TYPE=""
MODE=""
FINAL=""

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            start|complete|version-bump|log|track-change|correlate-files|generate-report|show-history|update-changelog)
                ACTION="$1"
                shift
                ;;
            --action)
                # Special handling for track-change sub-actions
                if [[ "$2" =~ ^(evolution-start|pre-version-update|post-version-update)$ ]]; then
                    ACTION="track-change"
                    TRACK_ACTION="$2"
                else
                    ACTION="$2"
                fi
                shift 2
                ;;
            --version)
                VERSION="$2"
                shift 2
                ;;
            --old-version)
                OLD_VERSION="$2"
                shift 2
                ;;
            --new-version)
                NEW_VERSION="$2"
                shift 2
                ;;
            --prompt)
                PROMPT="$2"
                shift 2
                ;;
            --format)
                FORMAT="$2"
                shift 2
                ;;
            --output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            --limit)
                LIMIT="$2"
                shift 2
                ;;
            --type)
                TYPE="$2"
                shift 2
                ;;
            --mode)
                MODE="$2"
                shift 2
                ;;
            --final)
                FINAL="true"
                shift
                ;;
            *)
                # Handle positional arguments for backward compatibility
                if [[ -z "$ACTION" ]]; then
                    ACTION="$1"
                else
                    # Store additional arguments for legacy function calls
                    break
                fi
                shift
                ;;
        esac
    done
}

# Initialize change tracking if it doesn't exist
initialize_change_tracking() {
    if [[ ! -f "$CHANGE_LOG_FILE" ]]; then
        cat > "$CHANGE_LOG_FILE" << EOF
{
  "tracking_initialized": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "version_changes": [],
  "file_correlations": {},
  "git_metadata": {}
}
EOF
        log_info "Initialized change tracking: $CHANGE_LOG_FILE"
    fi
}

# Get file hash for change detection
get_file_hash() {
    local file_path="$1"
    
    if [[ -f "$file_path" ]]; then
        shasum -a 256 "$file_path" | cut -d' ' -f1
    else
        echo "FILE_NOT_FOUND"
    fi
}

# Get git metadata for current state
get_git_metadata() {
    local metadata="{}"
    
    if git rev-parse --git-dir >/dev/null 2>&1; then
        local commit_hash=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
        local branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        local commit_date=$(git log -1 --format="%ci" 2>/dev/null | sed 's/ /T/' | sed 's/ .*/Z/' || echo "unknown")
        local author=$(git log -1 --format="%an <%ae>" 2>/dev/null || echo "unknown")
        
        metadata=$(jq -n \
            --arg commit "$commit_hash" \
            --arg branch "$branch" \
            --arg date "$commit_date" \
            --arg author "$author" \
            '{
                commit_hash: $commit,
                branch: $branch,
                commit_date: $date,
                author: $author
            }')
    fi
    
    echo "$metadata"
}

# Track a version change with associated file modifications
track_version_change() {
    local old_version="$1"
    local new_version="$2"
    local change_description="$3"
    local increment_type="$4"
    local modified_files="$5"  # JSON array of file paths
    
    initialize_change_tracking
    
    local change_id="v${new_version}-$(date +%s)"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local git_metadata=$(get_git_metadata)
    
    log_info "Tracking version change: $old_version → $new_version"
    
    # Create file correlation data
    local file_correlations="{}"
    if [[ -n "$modified_files" ]]; then
        echo "$modified_files" | jq -c '.[]' | while read -r file_path; do
            local clean_path=$(echo "$file_path" | tr -d '"')
            local file_hash=$(get_file_hash "$clean_path")
            local file_size=$(stat -f%z "$clean_path" 2>/dev/null || echo "0")
            
            file_correlations=$(echo "$file_correlations" | jq \
                --arg path "$clean_path" \
                --arg hash "$file_hash" \
                --arg size "$file_size" \
                --arg version "$new_version" \
                '.[$path] = {
                    hash: $hash,
                    size: $size,
                    last_version: $version,
                    modified_at: "'"$timestamp"'"
                }')
        done
        
        # Update change log with new entry
        local temp_file=$(mktemp)
        jq \
            --arg id "$change_id" \
            --arg old_ver "$old_version" \
            --arg new_ver "$new_version" \
            --arg desc "$change_description" \
            --arg type "$increment_type" \
            --arg timestamp "$timestamp" \
            --argjson git_meta "$git_metadata" \
            --argjson files "$modified_files" \
            --argjson correlations "$file_correlations" \
            '.version_changes += [{
                id: $id,
                old_version: $old_ver,
                new_version: $new_ver,
                description: $desc,
                increment_type: $type,
                timestamp: $timestamp,
                git_metadata: $git_meta,
                modified_files: $files,
                file_count: ($files | length)
            }] |
            .file_correlations += $correlations' \
            "$CHANGE_LOG_FILE" > "$temp_file" && mv "$temp_file" "$CHANGE_LOG_FILE"
    fi
    
    log_success "Tracked change: $change_id with $(echo "$modified_files" | jq length) files"
}

# Get files associated with a specific version
get_files_for_version() {
    local version="$1"
    
    if [[ ! -f "$CHANGE_LOG_FILE" ]]; then
        log_warn "Change tracking not initialized"
        return 1
    fi
    
    local files=$(jq -r \
        --arg version "$version" \
        '.version_changes[] | select(.new_version == $version) | .modified_files[]' \
        "$CHANGE_LOG_FILE" 2>/dev/null || echo "[]")
    
    echo "$files"
}

# Get version history for a specific file
get_version_history_for_file() {
    local file_path="$1"
    
    if [[ ! -f "$CHANGE_LOG_FILE" ]]; then
        log_warn "Change tracking not initialized"
        return 1
    fi
    
    local history=$(jq -r \
        --arg file "$file_path" \
        '[.version_changes[] | select(.modified_files[] == $file) | {
            version: .new_version,
            description: .description,
            timestamp: .timestamp,
            increment_type: .increment_type
        }] | sort_by(.timestamp)' \
        "$CHANGE_LOG_FILE" 2>/dev/null || echo "[]")
    
    echo "$history"
}

# Generate a correlation report between versions and files
generate_correlation_report() {
    local format="${1:-markdown}"
    local output_file="${2:-version-correlation-report.md}"
    
    if [[ ! -f "$CHANGE_LOG_FILE" ]]; then
        log_warn "Change tracking not initialized"
        return 1
    fi
    
    log_info "Generating correlation report in $format format"
    
    case "$format" in
        markdown)
            generate_markdown_report "$output_file"
            ;;
        json)
            cp "$CHANGE_LOG_FILE" "$output_file"
            ;;
        csv)
            generate_csv_report "$output_file"
            ;;
        *)
            log_error "Unsupported format: $format"
            ;;
    esac
}

# Generate markdown correlation report
generate_markdown_report() {
    local output_file="$1"
    
    cat > "$output_file" << 'EOF'
# Version-File Correlation Report

This report shows the relationship between version increments and file modifications in the AI Evolution Engine.

## Version History

EOF
    
    # Add version entries
    jq -r '.version_changes[] | 
        "### Version \(.new_version) (\(.increment_type) increment)\n" +
        "- **Date**: \(.timestamp)\n" +
        "- **Description**: \(.description)\n" +
        "- **Files Modified**: \(.file_count)\n" +
        "- **Git Commit**: \(.git_metadata.commit_hash // "unknown")\n" +
        "- **Branch**: \(.git_metadata.branch // "unknown")\n\n" +
        "#### Modified Files:\n" +
        (.modified_files | map("- `\(.)`") | join("\n")) + "\n\n"' \
        "$CHANGE_LOG_FILE" >> "$output_file"
    
    # Add file correlation section
    cat >> "$output_file" << 'EOF'

## File Modification Timeline

| File | Last Version | Hash | Last Modified |
|------|-------------|------|---------------|
EOF
    
    if jq -e '.file_correlations | length > 0' "$CHANGE_LOG_FILE" >/dev/null 2>&1; then
        jq -r '.file_correlations | to_entries[] | 
            "| `\(.key)` | \(.value.last_version) | `\(.value.hash[0:8])...` | \(.value.modified_at) |"' \
            "$CHANGE_LOG_FILE" >> "$output_file"
    else
        echo "| No file correlations tracked yet | - | - | - |" >> "$output_file"
    fi
    
    log_success "Generated markdown report: $output_file"
}

# Generate CSV correlation report
generate_csv_report() {
    local output_file="$1"
    
    echo "version,increment_type,description,timestamp,file_count,modified_files" > "$output_file"
    
    jq -r '.version_changes[] | 
        [.new_version, .increment_type, .description, .timestamp, .file_count, 
         (.modified_files | join(";"))] | @csv' \
        "$CHANGE_LOG_FILE" >> "$output_file"
    
    log_success "Generated CSV report: $output_file"
}

# Update CHANGELOG.md with file correlations
update_changelog_with_correlations() {
    local version="$1"
    local description="$2"
    local increment_type="$3"
    local modified_files="$4"
    
    if [[ ! -f "$CHANGELOG_FILE" ]]; then
        log_warn "CHANGELOG.md not found, skipping changelog update"
        return
    fi
    
    local current_date=$(date -u +"%Y-%m-%d")
    local temp_changelog=$(mktemp)
    local file_count=$(echo "$modified_files" | jq length)
    
    # Create enhanced changelog entry with file correlations
    {
        head -n 7 "$CHANGELOG_FILE"  # Keep header
        echo ""
        echo "## [$version] - $current_date"
        echo ""
        echo "### 🔄 Version Management ($increment_type increment)"
        echo "- **Description**: $description"
        echo "- **Files Modified**: $file_count files updated"
        echo "- **Change Tracking**: Full correlation available in \`version-changes.json\`"
        echo ""
        echo "#### 📝 Modified Files"
        echo "$modified_files" | jq -r '.[] | "- `\(.)`"'
        echo ""
        echo "#### 🔗 Quick Links"
        echo "- [View all changes for this version](#correlations-v${version//./})"
        echo "- [File modification history](version-correlation-report.md)"
        echo ""
        tail -n +8 "$CHANGELOG_FILE"  # Keep rest of file
    } > "$temp_changelog"
    
    mv "$temp_changelog" "$CHANGELOG_FILE"
    log_success "Updated CHANGELOG.md with file correlations for version $version"
}

# Show version history summary
show_version_history() {
    local limit="${1:-10}"
    
    if [[ ! -f "$CHANGE_LOG_FILE" ]]; then
        log_warn "Change tracking not initialized"
        return 1
    fi
    
    echo "Recent Version Changes (last $limit):"
    echo "======================================"
    
    jq -r \
        --arg limit "$limit" \
        '[.version_changes | reverse | .[:($limit | tonumber)][]] | 
         .[] | 
         "📦 Version \(.new_version) (\(.increment_type))\n" +
         "   📅 \(.timestamp)\n" +
         "   📝 \(.description)\n" +
         "   📁 \(.file_count) files modified\n" +
         "   🔗 Change ID: \(.id)\n"' \
        "$CHANGE_LOG_FILE"
}

# Show file correlation for specific file
show_file_correlation() {
    local file_path="$1"
    
    if [[ ! -f "$CHANGE_LOG_FILE" ]]; then
        log_warn "Change tracking not initialized"
        return 1
    fi
    
    echo "Version History for: $file_path"
    echo "==============================="
    
    local history=$(get_version_history_for_file "$file_path")
    
    if [[ "$history" == "[]" ]]; then
        echo "No version history found for this file."
        return
    fi
    
    echo "$history" | jq -r '.[] | 
        "📦 Version \(.version) (\(.increment_type))\n" +
        "   📅 \(.timestamp)\n" +
        "   📝 \(.description)\n"'
}

# Get tracked files that have changed since last version
get_changed_tracked_files() {
    local current_version="${1:-$(jq -r '.current_version // "0.0.0"' "$VERSION_CONFIG" 2>/dev/null)}"
    
    # Get list of tracked files from config
    local tracked_files=$(jq -r '.tracked_files.core_files[].path' "$VERSION_CONFIG" 2>/dev/null)
    local changed_files="[]"
    
    while IFS= read -r file_path; do
        if [[ -f "$file_path" ]]; then
            local current_hash=$(get_file_hash "$file_path")
            local last_known_hash=$(jq -r \
                --arg path "$file_path" \
                '.file_correlations[$path].hash // "unknown"' \
                "$CHANGE_LOG_FILE" 2>/dev/null)
            
            if [[ "$current_hash" != "$last_known_hash" ]]; then
                changed_files=$(echo "$changed_files" | jq --arg path "$file_path" '. += [$path]')
            fi
        fi
    done <<< "$tracked_files"
    
    echo "$changed_files"
}

# Handle different tracking actions
handle_track_action() {
    local action="$1"
    local version="$2"
    
    case "$action" in
        evolution-start)
            log_info "Starting evolution cycle tracking for version $version"
            initialize_change_tracking
            ;;
        pre-version-update)
            log_info "Capturing pre-update state for version $version"
            # Store current state of tracked files
            local changed_files=$(get_changed_tracked_files "$version")
            if [[ "$changed_files" != "[]" ]]; then
                log_info "Detected $(echo "$changed_files" | jq length) changed files before update"
                echo "$changed_files" > "/tmp/pre_update_files.json"
            fi
            ;;
        post-version-update)
            log_info "Capturing post-update state for version $version"
            # Store updated state of tracked files
            local changed_files=$(get_changed_tracked_files "$version")
            if [[ "$changed_files" != "[]" ]]; then
                log_info "Detected $(echo "$changed_files" | jq length) changed files after update"
                echo "$changed_files" > "/tmp/post_update_files.json"
            fi
            ;;
        *)
            log_warn "Unknown tracking action: $action"
            ;;
    esac
}

# Parse arguments first
parse_arguments "$@"

# Store remaining arguments for positional parameter handling
shift $((OPTIND-1)) 2>/dev/null || true
REMAINING_ARGS=("$@")

# Main action handlers
case "${ACTION:-help}" in
    start)
        # Start evolution cycle tracking
        log_info "Starting evolution cycle tracking..."
        if [[ -n "$VERSION" ]]; then
            handle_track_action "evolution-start" "$VERSION"
        else
            # Initialize change tracking for current version
            initialize_change_tracking
        fi
        log_success "Evolution cycle tracking started"
        ;;
    complete)
        # Complete evolution cycle tracking
        log_info "Completing evolution cycle tracking..."
        if [[ -n "$VERSION" ]]; then
            handle_track_action "post-version-update" "$VERSION"
        fi
        log_success "Evolution cycle tracking completed"
        ;;
    version-bump)
        # Handle version bump (this would typically be handled by version-integration.sh)
        log_info "Version bump requested - delegating to version integration system..."
        if [[ -f "$PROJECT_ROOT/scripts/version-integration.sh" ]]; then
            # Use evolution command with appropriate description
            description="${PROMPT:-Evolution cycle version update}"
            "$PROJECT_ROOT/scripts/version-integration.sh" evolution "$description"
        else
            log_warn "Version integration script not found - skipping version bump"
        fi
        ;;
    log)
        # Log final evolution tracking
        log_info "Recording final evolution tracking..."
        if [[ -n "$FINAL" ]]; then
            log_info "Final evolution cycle completed"
            # Generate final report
            generate_correlation_report "markdown" "evolution-final-report.md" 2>/dev/null || true
        fi
        show_version_history 5
        ;;
    track-change)
        if [[ -n "$TRACK_ACTION" && -n "$VERSION" ]]; then
            # Handle new style arguments with sub-actions
            handle_track_action "$TRACK_ACTION" "$VERSION"
        elif [[ -n "$VERSION" && -n "$ACTION" ]]; then
            # Handle new style arguments
            handle_track_action "$ACTION" "$VERSION"
        else
            # Handle legacy style arguments
            track_version_change "$1" "$2" "$3" "$4" "$5"
        fi
        ;;
    correlate-files)
        if [[ -n "$OLD_VERSION" && -n "$NEW_VERSION" ]]; then
            # Correlate changes between two versions
            log_info "Correlating file changes between $OLD_VERSION and $NEW_VERSION"
            
            # Get changed files from temp storage if available
            changed_files="[]"
            if [[ -f "/tmp/post_update_files.json" ]]; then
                changed_files=$(cat "/tmp/post_update_files.json")
            else
                changed_files=$(get_changed_tracked_files "$NEW_VERSION")
            fi
            
            if [[ "$changed_files" != "[]" ]]; then
                track_version_change "$OLD_VERSION" "$NEW_VERSION" "Evolution cycle file updates" "patch" "$changed_files"
                log_success "Correlated $(echo "$changed_files" | jq length) file changes"
            else
                log_info "No file changes detected to correlate"
            fi
        else
            # Get files for specific version
            get_files_for_version "${VERSION:-$1}"
        fi
        ;;
    show-history)
        show_version_history "${LIMIT:-10}"
        ;;
    file-history)
        # Use remaining arguments or version parameter
        file_path="${REMAINING_ARGS[1]:-$VERSION}"
        [[ -z "$file_path" ]] && file_path="${REMAINING_ARGS[0]:-}"
        show_file_correlation "$file_path"
        ;;
    generate-report)
        output="${OUTPUT_FILE:-version-correlation-report.${FORMAT}}"
        generate_correlation_report "$FORMAT" "$output"
        ;;
    update-changelog)
        if [[ -n "$VERSION" && -n "$PROMPT" ]]; then
            # Use workflow arguments
            changed_files="[]"
            if [[ -f "/tmp/post_update_files.json" ]]; then
                changed_files=$(cat "/tmp/post_update_files.json")
            fi
            update_changelog_with_correlations "$VERSION" "$PROMPT" "patch" "$changed_files"
        else
            # Use legacy arguments
            update_changelog_with_correlations "$1" "$2" "$3" "$4"
        fi
        ;;
    help|--help|-h)
        cat << EOF
Version Tracker - Advanced Change Correlation System

Usage: $0 [command] [arguments]

Workflow Commands (used by CI/CD):
  $0 start --type manual --mode adaptive --prompt "description"
    Start evolution cycle tracking
    
  $0 complete --mode adaptive
    Complete evolution cycle tracking
    
  $0 version-bump
    Trigger version bump (delegates to version-integration.sh)
    
  $0 log --final --mode adaptive
    Log final evolution tracking and generate reports

Modern Usage (with flags):
  $0 track-change --action evolution-start --version 0.3.3
  $0 track-change --action pre-version-update --version 0.3.3
  $0 correlate-files --old-version 0.3.2 --new-version 0.3.3
  $0 generate-report --format markdown --output evolution-report.md
  $0 show-history --version 0.3.3 --format summary
  $0 update-changelog --version 0.3.3 --prompt "Evolution cycle description"

Legacy Commands:
  track-change [old_ver] [new_ver] [description] [type] [files_json]
    Track a version change with associated file modifications
    
  correlate-files [version]
    Get all files associated with a specific version
    
  file-history [file_path]
    Show version history for a specific file
    
  generate-report [format] [output_file]
    Generate correlation report (markdown, json, csv)
    
  show-history [limit]
    Show recent version changes (default: 10)
    
  update-changelog [version] [description] [type] [files_json]
    Update CHANGELOG.md with file correlations

Examples:
  $0 start --type manual --mode adaptive --prompt "Update documentation"
  $0 track-change "0.3.2" "0.3.3" "Added version management" "patch" '["README.md"]'
  $0 correlate-files "0.3.3"
  $0 file-history "README.md"
  $0 generate-report markdown version-report.md
  $0 show-history 5
EOF
        ;;
    *)
        echo "Unknown command: ${ACTION:-$1}"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
